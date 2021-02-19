//
//  CitiesQueriesRepository.swift
//  WeatherApp
//
//  Created by Amir on 1/23/21.
//

import UIKit

protocol CitiesQueriesRepository
{
    func fetchRecentsQueries(completion: @escaping (Result<[String], Error>) -> Void)
    func saveRecentQuery(_ query: String, completion: @escaping (Result<[String], Error>) -> Void)
    func removeQuery(_ query: String, completion: @escaping (Result<[String], Error>) -> Void)
}
