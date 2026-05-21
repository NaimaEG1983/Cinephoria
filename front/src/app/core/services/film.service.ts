import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Film } from '../models/film.model'; // Ajustez le chemin selon votre projet

@Injectable({
  providedIn: 'root'
})
export class FilmService {

  private apiUrl = 'http://localhost:3000/api/films'; 

  constructor(private http: HttpClient) { }

  /**
   * Récupère TOUS les films du catalogue (Typé avec le modèle Film)
   */
  getFilms(): Observable<Film[]> {
    return this.http.get<Film[]>(this.apiUrl);
  }

  /**
   * Récupère uniquement les nouveautés du dernier mercredi
   */
  getDerniersFilms(): Observable<Film[]> {
    return this.http.get<Film[]>(`${this.apiUrl}/nouveautes`);
  }
}