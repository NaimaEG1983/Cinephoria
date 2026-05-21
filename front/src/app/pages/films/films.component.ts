import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Film } from '../../core/models/film.model';
import { FilmService } from '../../core/services/film.service';
import { DureeFormatPipe } from '../../pipes/duree-format.pipe';
import { environment } from '../../../environments/environment';

@Component({
  selector: 'app-films',
  standalone: true,
  imports: [CommonModule, DureeFormatPipe],
  templateUrl: './films.component.html',
  styleUrls: ['./films.component.css']
})
export class FilmsComponent implements OnInit {
  
  // Tableau qui stockera l'intégralité des films du catalogue
  derniersFilms: Film[] = []; 
  voirTout: boolean = false;

  constructor(private filmService: FilmService) { }

  ngOnInit(): void {
    // MODIFICATION ICI : On utilise getFilms() pour charger TOUS les films
    this.filmService.getFilms().subscribe({
      next: (data: Film[]) => {
        this.derniersFilms = data; 
        console.log('Tous les films du catalogue chargés :', this.derniersFilms);
      },
      error: (err: any) => {
        console.error('Erreur lors du chargement de tous les films :', err);
      }
    });
  }

  // Le "getter" qui applique la transformation des images sur tout le catalogue
  get filmsAffiches(): Film[] {
    // Si 'voirTout' est faux, on affiche les 8 premiers films (2 lignes de cartes)
    // Dès que l'utilisateur clique sur "Voir plus", tout le catalogue s'affiche
    const listeFilms = this.voirTout ? this.derniersFilms : this.derniersFilms.slice(0, 8);

    // Traitement des URLs d'images Node.js (identique à l'accueil)
    return listeFilms.map(film => ({
      ...film,
      affiche_image: film.affiche_image.startsWith('http') 
        ? film.affiche_image 
        : `${environment.imagesUrl}/${film.affiche_image}`
    }));
  }
}