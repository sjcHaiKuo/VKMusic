//
//  Player.swift
//  VkPlaylist
//
//  Created by Илья Халяпин on 09.06.16.
//  Copyright © 2016 Ilya Khalyapin. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

final class Player: NSObject {
    
    /// Системный плеер
    var player: AVPlayer?
    /// Наблюдатель за изменениями о прогрессе воспроизведения
    var progressObserver: AnyObject!
    /// Наблюдатель за изменениями меток со временем воспроизведения
    var currentTimeObserver: AnyObject!
    /// Идентификатор задачи в фоне
    var backgroundIdentifier = UIBackgroundTaskInvalid
    
    /// Делегат плеера
    weak var delegate: PlayerDelegate?
    
    /// Индекс воспроизводимого трека
    var playIndex = 0
    /// Очередь на воспроизведение
    var queuedItems = [PlayerItem]()
    /// Состояние плеера
    var state = PlayerState.Ready {
        didSet {
            if oldValue != state {
                delegate?.playerStateDidChange(self)
            }
        }
    }
    
    /// Текущий элемент плеера
    var currentItem: PlayerItem? {
        guard playIndex >= 0 && playIndex < queuedItems.count else {
            return nil
        }
        
        return queuedItems[playIndex]
    }
    
    /// Доступно ли воспроизведение
    var playerOperational: Bool {
        return player != nil && currentItem != nil
    }
    
    
    init(delegate: PlayerDelegate? = nil) {
        self.delegate = delegate
        
        super.init()
        
        configureObservers()
        configureAudioSession()
        
        // Подписываем приложение на получение событий удаленного контроля
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: Настройки
    
    /// Настройка аудио-сессии
    func configureAudioSession() {
        do {
            // Установка категории аудио-сессии - воспроизведение музыки (чтобы приложение позволяло воспроизводить музыку в фоне, необходимо добавить значение "audio" для ключа UIBackgroundModes на странице настроек приложения)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            // Активирует аудио-сессию
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            fatalError("Could not open the audio session, hence Player is unusable!")
        }
    }
    
    /// Создание фоновой задачи воспроизведения аудиозаписи
    private func configureBackgroundAudioTask() {
        backgroundIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
            UIApplication.sharedApplication().endBackgroundTask(self.backgroundIdentifier)
            self.backgroundIdentifier = UIBackgroundTaskInvalid
        }
    }
    
    /// Настройка слушателей уведомлений
    func configureObservers() {
        registerForPlaybackStalledNotification()
    }
    
    
    // MARK: Обработка окончания воспроизведения
    
    /// Подписка на уведомление об окончании воспроизведения элемента системного плеера для указанного элемента системного плеера
    private func registerForPlayToEndNotificationWithItem(item: AVPlayerItem) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(playerItemDidPlayToEnd), name: AVPlayerItemDidPlayToEndTimeNotification, object: item)
    }
    
    /// Обработка уведомления о том, что воспроизводимый элемент системного плеера закончился
    func playerItemDidPlayToEnd() {
        unregisterForPlayToEndNotificationWithItem(currentItem!.playerItem!)
        currentItem!.removeBufferProgressObserver()
        
        /// Если это был последний элемент в очереди на воспроизведение
        if playIndex >= queuedItems.count - 1 {
            clear()
        } else {
            playAtIndex(playIndex + 1)
        }
    }
    
    /// Отписка от уведомлений об окончании воспроизведения элемента системного плеера для указанного элемента системного плеера
    func unregisterForPlayToEndNotificationWithItem(item: AVPlayerItem) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: item)
    }
    
    
    // MARK: Обработка низкой скорости подключения
    
    /// Подписка на уведомление о том, что часть медиа-файла не успела загрузиться из сети, чтобы быть воспроизведенной
    func registerForPlaybackStalledNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleStall), name: AVPlayerItemPlaybackStalledNotification, object: nil)
    }
    
    /// Обработка уведомления о том, что часть медиа-файла не успела загрузиться из сети, чтобы быть воспроизведенной
    func handleStall() {
        player?.pause()
        
        if state == .Playing {
            player?.play()
        }
    }
    
    
    // MARK: Работа с элементами плеера
    
    /// Сохранение аудиозаписей в очередь
    func assignQueuedItems(items: [PlayerItem]) {
        queuedItems = items
        
        for item in queuedItems {
            item.delegate = self
        }
    }
    
    
    // MARK: Воспроизведение
    
    /// Обновление всего инфо-центра "Воспроизводится сейчас"
    func updateInfoCenter() {
        guard let item = currentItem else {
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nil
            return
        }
        
        let title = item.title ?? ""
        let artist = item.artist ?? ""
        let currentTime = item.currentTime ?? 0
        let duration = item.duration ?? 0
        let trackNumber = playIndex
        let trackCount = queuedItems.count
        
        let nowPlayingInfo: [String : AnyObject] = [
            MPMediaItemPropertyTitle : title,
            MPMediaItemPropertyArtist : artist,
            MPMediaItemPropertyPlaybackDuration : duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime : currentTime,
            MPNowPlayingInfoPropertyPlaybackQueueCount : trackCount,
            MPNowPlayingInfoPropertyPlaybackQueueIndex : trackNumber,
            MPMediaItemPropertyMediaType : MPMediaType.Music.rawValue,
            /**/MPMediaItemPropertyArtwork : MPMediaItemArtwork(image: UIImage(named: "placeholder-Player")!)
        ]
        
//        if let artwork = currentItem?.artwork {
//            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: artwork)
//        }
        
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nowPlayingInfo
    }
    
    /// Начать воспроизведение нового элемента системного плеера
    func startNewPlayerForItem(item: AVPlayerItem) {
        
        // Отменяем воспроизведение прошлой аудиозаписи
        stopProgressObserving()
        player?.pause()
        player = nil
        
        // Начинаем воспроизведение новой аудиозаписи
        player = AVPlayer(playerItem: item)
        startProgressObserving()
        
        seekToSecond(0, shouldPlay: true)
    }
    
    /// Продолжить воспроизведение
    func resumePlayback() {
        if state != .Playing {
            if let player = player {
                startProgressObserving()
                player.play()
                
                state = .Playing
                
                updateInfoCenter()
            } else {
                startNewPlayerForItem(currentItem!.playerItem!)
            }
        }
    }
    
    
    // MARK: Отслеживание прогресса
    
    /// Начать наблюдение за показателями прогресса воспроизведения
    func startProgressObserving() {
        startProgressTimer()
        startCurrentTimeUpdate()
    }
    
    /// Прекратить наблюдение за показателями прогресса воспроизведения
    func stopProgressObserving() {
        stopProgressTimer()
        stopCurrentTimeUpdate()
    }
    
    /// Начать наблюдение за прогрессом воспроизведения
    func startProgressTimer() {
        guard let player = player where progressObserver == nil else {
            return
        }
        
        let interval = 0.5 * currentItem!.duration! / Double(PlayerManager.sharedInstance.barWidth)
        
        progressObserver = player.addPeriodicTimeObserverForInterval(CMTimeMakeWithSeconds(interval, Int32(NSEC_PER_SEC)), queue: nil) { [unowned self] _ in
            self.syncProgress()
        }
    }
    
    /// Прекратить наблюдение за прогрессом воспроизведения
    func stopProgressTimer() {
        guard let player = player, let progressObserver = progressObserver else {
            return
        }
        
        player.removeTimeObserver(progressObserver)
        self.progressObserver = nil
    }
    
    /// Начать наблюдение за текущим временем воспоизведения
    func startCurrentTimeUpdate() {
        guard let player = player where currentTimeObserver == nil else {
            return
        }
        
        currentTimeObserver = player.addPeriodicTimeObserverForInterval(CMTimeMakeWithSeconds(1, Int32(NSEC_PER_SEC)), queue: nil) { [unowned self] _ in
            self.syncCurrentTime()
        }
    }
    
    /// Прекратить наблюдение за текущим временем воспроизведения
    func stopCurrentTimeUpdate() {
        guard let player = player, let currentTimeObserver = currentTimeObserver else {
            return
        }
        
        player.removeTimeObserver(currentTimeObserver)
        self.currentTimeObserver = nil
    }
    
    
    // MARK: Работа с уведомлениями о прогрессе
    
    /// Обновление значений прогресса и текущего времени для текущего элемента
    func syncValues() {
        syncProgress()
        syncCurrentTime()
        syncBufferingProgress()
    }
    
    /// Обновление значения прогресса воспроизведения для текущего элемента плеера
    func syncProgress() {
        guard let _ = player?.currentItem, let _ = currentItem?.currentTime else {
            return
        }
        
        delegate?.playerPlaybackProgressDidChange(self)
    }
    
    /// Обновление значения текущего времени воспроизведения для текущего элемента плеера
    func syncCurrentTime() {
        guard let _ = player?.currentItem, let _ = currentItem?.currentTime else {
            return
        }
        
        delegate?.playerPlaybackCurrentTimeDidChange(self)
    }
    
    /// Обновление значения текущего прогресса буфферизации для текущего элемента плеера
    func syncBufferingProgress() {
        guard let _ = player?.currentItem, let _ = currentItem?.currentTime else {
            return
        }
        
        delegate?.playerBufferingProgressDidChange(self)
    }
    
}


// MARK: PlayerItemDelegate

extension Player: PlayerItemDelegate {

    // Элемент плеера предзагрузил текущую аудиозапись со следующей величиной
    func playerItemDidPreLoadCurrentItemWithProgress(preloadProgress: Float) {
        syncBufferingProgress()
    }
    
}


// MARK: Публичные методы

extension Player {
    
    /// Начать воспроизведение
    func play() {
        playAtIndex(playIndex)
    }
    
    /// Воспроизвести элемент плеера по указанному индексу
    func playAtIndex(index: Int) {
        guard index >= 0 && index < queuedItems.count else {
            return
        }
        
        configureBackgroundAudioTask()
        
        if let _ = queuedItems[index].playerItem where playIndex == index {
            if PlayerManager.sharedInstance.isPauseActive {
                resumePlayback()
            } else {
                seekToSecond(0, shouldPlay: true)
            }
        } else {
            if let playerItem = currentItem?.playerItem {
                unregisterForPlayToEndNotificationWithItem(playerItem)
                currentItem!.removeBufferProgressObserver()
            }
            
            playIndex = index
            
            let playerItem = currentItem!.getPlayerItem()
            
            registerForPlayToEndNotificationWithItem(playerItem)
            currentItem!.addBufferProgressObserver()
            
            startNewPlayerForItem(playerItem)
            
            delegate?.playerCurrentItemDidChange(self)
        }
    }
    
    /// Поставить воспроизведение на паузу
    func pause() {
        stopProgressObserving()
        
        player?.pause()
        state = .Paused
    }
    
    /// Очистить все данные плеера
    func clear() {
        stopProgressObserving()
        if let playerItem = currentItem?.playerItem {
            unregisterForPlayToEndNotificationWithItem(playerItem)
            currentItem!.removeBufferProgressObserver()
        }
        
        player?.pause()
        player = nil
        
        playIndex = 0
        queuedItems.removeAll()
        
        UIApplication.sharedApplication().endBackgroundTask(backgroundIdentifier)
        backgroundIdentifier = UIBackgroundTaskInvalid
        
        updateInfoCenter()
        
        state = .Ready
    }
    
    /// Воспроизвести предыдущий элемент плеера
    func playPrevious() {
        guard playerOperational else {
            return
        }
        
        if currentItem!.currentTime > 5 {
            replayCurrentItem()
            return
        }
        
        if playIndex - 1 < 0 {
            clear()
            return
        }
        
        playAtIndex(playIndex - 1)
        syncValues()
    }
    
    /// Начать воспроизведение следующего элемента плеера
    func playNext() {
        guard playerOperational else {
            return
        }
        
        if playIndex + 1 >= queuedItems.count {
            clear()
            return
        }
        
        playAtIndex(playIndex + 1)
        syncValues()
    }
    
    /// Начать воспроизведение с начала очереди
    func replay(){
        guard playerOperational else {
            return
        }
        
        stopProgressObserving()
        
        seekToSecond(0)
        playAtIndex(0)
    }
    
    /// Воспроизвести заново текущий элемент плеера
    func replayCurrentItem() {
        guard playerOperational else {
            return
        }
        
        seekToSecond(0, shouldPlay: true)
    }
    
    /// Перемотать элемент плеера на указанную секунду
    func seekToSecond(second: Int, shouldPlay: Bool = false) {
        guard let player = player, let _ = currentItem else {
            return
        }
        
        player.seekToTime(CMTimeMakeWithSeconds(Float64(second), Int32(NSEC_PER_SEC)))
        
        if shouldPlay {
            startProgressObserving()
            player.play()
            
            state = .Playing
        }
        
        updateInfoCenter()
        
        delegate?.playerPlaybackProgressDidChange(self)
    }
    
}