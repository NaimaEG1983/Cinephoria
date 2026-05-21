import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'dureeFormat', 
  standalone: true
})
export class DureeFormatPipe implements PipeTransform {

  transform(totalMinutes: number | null | undefined): string {
    if (!totalMinutes || isNaN(totalMinutes)){
        return '0h00min';
    }
  // Calcul des heures et des minutes
  const heures = Math.floor(totalMinutes / 60);
  const minutes = totalMinutes % 60;

  // Ajoute un '0' devant les minutes si elles sont inférieures à 10 (ex: 2h05 au lieu de 2h5)
  const minutesFormatees = minutes < 10 ? `0${minutes}` : minutes;

  return `${heures}h${minutesFormatees}min`;
  }

}
