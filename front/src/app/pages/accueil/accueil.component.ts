import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-accueil',
  standalone: true,
  imports: [RouterLink],
  templateUrl: './accueil.component.html',
  styleUrl: './accueil.component.css'
})
export class AccueilComponent {
  
  // Par défaut, on n'affiche pas tout si le tableau est très grand
  voirTout = false;

  derniersFilms = [
    { titre: 'Intouchables', genre: 'Comédie, Drame', duree: '1h52min', image: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=400&auto=format&fit=crop' },
    { titre: 'Toy Story', genre: 'Animation, Comédie', duree: '1h21min', image: 'https://images.unsplash.com/photo-1608889174639-414d9f96dd81?q=80&w=400&auto=format&fit=crop' },
    { titre: 'Inception', genre: 'Science-Fiction, Action', duree: '2h28min', image: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?q=80&w=400&auto=format&fit=crop' },
    { titre: 'The Dark Knight', genre: 'Drame, Action', duree: '2h32min', image: 'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?q=80&w=400&auto=format&fit=crop' },
    // J'ajoute deux films fictifs pour tester le système "Voir plus" :
    { titre: 'Interstellar', genre: 'SF, Drame', duree: '2h49min', image: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=400&auto=format&fit=crop' },
    { titre: 'Avatar', genre: 'Action, Aventure', duree: '2h42min', image: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?q=80&w=400&auto=format&fit=crop' }
  ];

  // Cette fonction renvoie soit les 4 premiers films, soit la totalité
  get filmsAffiches() {
    return this.voirTout ? this.derniersFilms : this.derniersFilms.slice(0, 4);
  }
}