//
//  VKAPIManagerNotifications.swift
//  VkPlaylist
//
//  MIT License
//
//  Copyright (c) 2016 Ilya Khalyapin
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

// Уведомления о событиях при авторизации

/// Уведомление о том, что авторизация успешно пройдена
let VKAPIManagerDidAutorizeNotification = "VKAPIManagerDidAutorizeNotification"
/// Уведомление о том, что была произведена деавторизация
let VKAPIManagerDidUnautorizeNotification = "VKAPIManagerDidUnautorizeNotification"
/// Уведомление о том, что при авторизации была ошибка
let VKAPIManagerAutorizationFailedNotification = "VKAPIManagerAutorizationFailedNotification"


// Уведомления о событиях при получения личных аудиозаписей

/// Уведомление о том, что список личных аудиозаписей был получен
let VKAPIManagerDidGetAudioNotification = "VKAPIManagerDidGetAudioNotification"
/// Уведомление о том, что при получении личных аудиозаписей произошла ошибка при подключении к интернету
let VKAPIManagerGetAudioNetworkErrorNotification = "VKAPIManagerGetAudioNetworkErrorNotification"
/// Уведомление о том, что при получении личных аудиозаписей произошла ошибка
let VKAPIManagerGetAudioErrorNotification = "VKAPIManagerGetAudioErrorNotification"


// Уведомления о событиях при получения искомых аудиозаписей

/// Уведомление о том, что список искомых аудиозаписей был получен
let VKAPIManagerDidSearchAudioNotification = "VKAPIManagerDidSearchAudioNotification"
/// Уведомление о том, что при получении искомых аудиозаписей произошла ошибка при подключении к интернету
let VKAPIManagerSearchAudioNetworkErrorNotification = "VKAPIManagerSearchAudioNetworkErrorNotification"
/// Уведомление о том, что при получении искомых аудиозаписей произошла ошибка
let VKAPIManagerSearchAudioErrorNotification = "VKAPIManagerSearchAudioErrorNotification"


// Уведомления о событиях при получения альбомов пользователя

/// Уведомление о том, что список популярных альбомов был получен
let VKAPIManagerDidGetAlbumsNotification = "VKAPIManagerDidGetAlbumsNotification"
/// Уведомление о том, что при получении альбомов произошла ошибка при подключении к интернету
let VKAPIManagerGetAlbumsNetworkErrorNotification = "VKAPIManagerGetAlbumsNetworkErrorNotification"
/// Уведомление о том, что при получении альбомов произошла ошибка
let VKAPIManagerGetAlbumsErrorNotification = "VKAPIManagerGetAlbumsErrorNotification"


// Уведомления о событиях при получения аудиозаписей из указанного альбома

/// Уведомление о том, что список популярных альбомов был получен
let VKAPIManagerDidGetAudioForAlbumNotification = "VKAPIManagerDidGetAudioForAlbumNotification"
/// Уведомление о том, что при получении альбомов произошла ошибка при подключении к интернету
let VKAPIManagerGetAudioForAlbumNetworkErrorNotification = "VKAPIManagerGetAudioForAlbumNetworkErrorNotification"
/// Уведомление о том, что при получении альбомов произошла ошибка
let VKAPIManagerGetAudioForAlbumErrorNotification = "VKAPIManagerGetAudioForAlbumErrorNotification"


// Уведомления о событиях при получения списка друзей

/// Уведомление о том, что список друзей был получен
let VKAPIManagerDidGetFriendsNotification = "VKAPIManagerDidGetFriendsNotification"
/// Уведомление о том, что при получении друзей произошла ошибка при подключении к интернету
let VKAPIManagerGetFriendsNetworkErrorNotification = "VKAPIManagerGetFriendsNetworkErrorNotification"
/// Уведомление о том, что при получении друзей произошла ошибка
let VKAPIManagerGetFriendsErrorNotification = "VKAPIManagerGetFriendsErrorNotification"


// Уведомления о событиях при получения списка групп

/// Уведомление о том, что список групп был получен
let VKAPIManagerDidGetGroupsNotification = "VKAPIManagerDidGetGroupsNotification"
/// Уведомление о том, что при получении групп произошла ошибка при подключении к интернету
let VKAPIManagerGetGroupsNetworkErrorNotification = "VKAPIManagerGetGroupsNetworkErrorNotification"
/// Уведомление о том, что при получении групп произошла ошибка
let VKAPIManagerGetGroupsErrorNotification = "VKAPIManagerGetGroupsErrorNotification"


// Уведомления о событиях при получения списка друзей

/// Уведомление о том, что список аудиозаписей указанного пользователя был получен
let VKAPIManagerDidGetAudioForOwnerNotification = "VKAPIManagerDidGetAudioForOwnerNotification"
/// Уведомление о том, что при получении аудиозаписей указанного пользователя произошла ошибка при подключении к интернету
let VKAPIManagerGetAudioForOwnerNetworkErrorNotification = "VKAPIManagerGetAudioForOwnerNetworkErrorNotification"
/// Уведомление о том, что при получении аудиозаписей указанного пользователя произошла ошибка доступа
let VKAPIManagerGetAudioForOwnerAccessErrorNotification = "VKAPIManagerGetAudioForOwnerAccessErrorNotification"
/// Уведомление о том, что при получении аудиозаписей указанного пользователя произошла ошибка
let VKAPIManagerGetAudioForOwnerErrorNotification = "VKAPIManagerGetAudioForOwnerErrorNotification"


// Уведомления о событиях при получения рекомендуемых аудиозаписей

/// Уведомление о том, что список рекомендуемых аудиозаписей был получен
let VKAPIManagerDidGetRecommendationsAudioNotification = "VKAPIManagerDidGetRecommendationsAudioNotification"
/// Уведомление о том, что при получении рекомендуемых аудиозаписей произошла ошибка при подключении к интернету
let VKAPIManagerGetRecommendationsAudioNetworkErrorNotification = "VKAPIManagerGetRecommendationsAudioNetworkErrorNotification"
/// Уведомление о том, что при получении рекомендуемых аудиозаписей произошла ошибка
let VKAPIManagerGetRecommendationsAudioErrorNotification = "VKAPIManagerGetRecommendationsAudioErrorNotification"


// Уведомления о событиях при получения популярных аудиозаписей

/// Уведомление о том, что список популярных аудиозаписей был получен
let VKAPIManagerDidGetPopularAudioNotification = "VKAPIManagerDidGetPopularAudioNotification"
/// Уведомление о том, что при получении популярных аудиозаписей произошла ошибка при подключении к интернету
let VKAPIManagerGetPopularAudioNetworkErrorNotification = "VKAPIManagerGetPopularAudioNetworkErrorNotification"
/// Уведомление о том, что при получении популярных аудиозаписей произошла ошибка
let VKAPIManagerGetPopularAudioErrorNotification = "VKAPIManagerGetPopularAudioErrorNotification"
