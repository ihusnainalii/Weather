//
//  CitiesStorage.swift
//  WeatherApp
//
//  Created by Amir on 1/19/21.
//

import UIKit
///Required functionality to keep city data
public protocol CitiesStorage
{
    func fetchRecentsCities(completion: @escaping (Result<[String], Error>) -> Void)
    func saveRecentCity(_ cityName: String, completion: @escaping (Result<[String], Error>) -> Void)
    func removeCity(_ cityName: String, completion: @escaping (Result<[String], Error>) -> Void)
}
