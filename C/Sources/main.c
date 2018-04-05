#include "../Includes/fonction.h"

#define MemoryRead(A)     (*(volatile unsigned int*)(A))
#define MemoryWrite(A,V) *(volatile unsigned int*)(A)=(V)



int main(int argc, char ** argv)
{
	unsigned int game = 0; // 0: attend de l'innitialisation du LFSR   1: début du jeu	2: fin de jeu
	unsigned int lfsr = 0;
	unsigned int tiret_jeu = 0; //séquence des tiret à afficher(2bits par tirets) 00:vide 01:gauche 10:centre 11:droite
	unsigned int new_tiret = 0;
	unsigned int time_jeu = 0;//temps de descente des tirets en millisecondes
	unsigned int button = 0;//valeur de bouton mémorisé
	unsigned int huit_premier_tour, score = 0;//huit premier tour avant incrémentation du score
	unsigned int i, aller_retour_chenillard = 0;

	MemoryWrite(SEVEN_SEGMENT_RST, 1); // reset the 7 segment controler
	MemoryWrite(CTRL_SL_RST, 1); // reset the sw/led controler
	MemoryWrite(SEVEN_SEGMENT_REG, ((score << 20)&0xFFF00000) | ((game << 16)&0x000F0000) | (tiret_jeu&0x0000FFFF)); //Affiche PUSH
	puts("=================================================================\n");
	puts("Appuyer sur un bouton poussoir pour commencer une nouvelle partie\n");
	puts("=================================================================\n");
	while(MemoryRead(BUTTONS_VALUES) == 0){};
	puts("La partie commence !\n");

	while(1)
	{

		wait(500);
		lfsr = r_timer();
		tiret_jeu = 0;
		score = 0;
		huit_premier_tour = 0;
		game = 1;
		MemoryWrite(CTRL_SL_RST, 1); // reset the sw/led controler
		MemoryWrite(SEVEN_SEGMENT_RST, 1); // reset the 7 segment controler

		do
		{
			lfsr = my_lfsr(lfsr);
			new_tiret =((lfsr>>9) & (1u<<15)) | ((lfsr<<7) & (1u<<14)); //new_tiret sur les bits 14 et 15 obtenu avec bits 24 et 7 du lfsr
			tiret_jeu = (new_tiret | (tiret_jeu>>2) )  & 0xFFFF;
			MemoryWrite(SEVEN_SEGMENT_REG, ((score << 20)&0xFFF00000) | ((game << 16)&0x000F0000) | (tiret_jeu&0x0000FFFF));
			
			time_jeu = time_level(score);
			button = 0;
			for (i = 0; i < time_jeu; i++) {
				if(button == 0)
				{
					button = MemoryRead(BUTTONS_VALUES);
					time_level(score);
				}
				wait(1);
			}

			if(huit_premier_tour > 7)
			{
				score++;
			}
			else
			{
				huit_premier_tour++;
			}

		} while((tiret_jeu & 0b11) == butt_to_tiret(button) ); //compare la valeur du dernier afficheur avec les boutons


		puts("La partie fini votre score est de ");
		print_int(score);
		puts(" !!!\n\n\n");

		game = 2;
		MemoryWrite(SEVEN_SEGMENT_REG, ((score << 20)&0xFFF00000) | ((game << 16)&0x000F0000) | (tiret_jeu&0x0000FFFF));
		wait(500);
		puts("=================================================================\n");
		puts("Appuyer sur un bouton poussoir pour commencer une nouvelle partie\n");
		puts("=================================================================\n");
		i = 0;
		aller_retour_chenillard = 0;
		while(MemoryRead(BUTTONS_VALUES) == 0)
		{
			MemoryWrite(CTRL_SL_RW, ((1u<<(15-i)) | (1u<<(i))) & 0xFFFF); //chenillard effet miroir
			if(aller_retour_chenillard == 0)
			{
				i++;
				if(i == 7){aller_retour_chenillard = 1;}
			}
			else
			{
				i--;
				if(i == 0){aller_retour_chenillard = 0;}
			}
			wait(100);
		};

	}
}
