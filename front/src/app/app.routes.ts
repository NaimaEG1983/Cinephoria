import { Routes } from '@angular/router';
import { AccueilComponent } from './pages/accueil/accueil.component';
import { FilmsComponent } from './pages/films/films.component';
import { ConnectComponent } from './pages/connect/connect.component';
import { ContactComponent } from './pages/contact/contact.component';

export const routes: Routes = [
    { path: '', component: AccueilComponent },
    { path: 'films', component: FilmsComponent },
    { path: 'connexion', component: ConnectComponent },
    { path: 'contact', component: ContactComponent },
    { path: '**', redirectTo: '' } //redirection vers l'accueilsi l'URL n'existe pas 
];
