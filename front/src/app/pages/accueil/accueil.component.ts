import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { Film } from '../../core/models/film.model';
import { FilmService } from '../../core/services/film.service';
import { DureeFormatPipe } from '../../pipes/duree-format.pipe';
import { environment } from '../../../environments/environment';

@Component({
  selector: 'app-accueil',
  standalone: true,
  imports: [CommonModule, DureeFormatPipe],
  templateUrl: './accueil.component.html',
  styleUrls: ['./accueil.component.css']
})
export class AccueilComponent implements OnInit {
  
  // Déclaration des variables d'instance indispensables pour le HTML
  derniersFilms: Film[] = []; 
  voirTout: boolean = false;

  constructor(private filmService: FilmService) { }

  ngOnInit(): void {
    // Récupération des données depuis le Service
    this.filmService.getDerniersFilms().subscribe({
      next: (data: Film[]) => {
        this.derniersFilms = data; // Stocke l'ensemble des films de la semaine
        console.log('Films chargés avec succès :', this.derniersFilms);
      },
      error: (err: any) => {
        console.error('Erreur lors du chargement des nouveautés :', err);
      }
    });
  }

  // Le "getter" qui génère dynamiquement la propriété 'filmsAffiches'
  get filmsAffiches(): Film[] {
  // 1. On récupère la liste des films (tous ou les 4 premiers)
  const listeFilms = this.voirTout ? this.derniersFilms : this.derniersFilms.slice(0, 4);

  // 2. On transforme (map) la propriété 'affiche_image' pour y ajouter l'URL de l'API Node
  return listeFilms.map(film => ({
    ...film,
    // Si l'image commence déjà par http, on la laisse, sinon on construit l'URL locale
    affiche_image: film.affiche_image.startsWith('http') 
      ? film.affiche_image 
      : `${environment.imagesUrl}/${film.affiche_image}`
  }));
}
}