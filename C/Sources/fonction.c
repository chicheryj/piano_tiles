#include "../Includes/fonction.h"

//======================================================================================
//fonction qui impose un delay en millisecondes
//======================================================================================
void wait( unsigned int ms )
{
	unsigned int t0 = MemoryRead( TIMER_ADR  );
	while ( MemoryRead( TIMER_ADR  ) - t0 < (FREQ_HORLOGE/1000)*ms )
		;
}


//======================================================================================
//fonctionnement du LFSR: entre une séquence 32bits et renvoie le séquence suivante
//======================================================================================
unsigned int my_lfsr(unsigned int lfsr)
{
  unsigned int bit  = ((lfsr >> 1) ^ (lfsr >> 5) ^ (lfsr >> 6) ^ (lfsr >> 31) ) & 1; //XOR placé sur les bits 1, 5, 6, 31
  return lfsr =  (lfsr >> 1) | (bit << 31);
}


//======================================================================================
//transforme les valeurs des boutons vers les valeurs équivalent de tirets du jeu
//======================================================================================
unsigned int butt_to_tiret(unsigned int button)
{
	if(button == 1)//bouton central
	{
		return 0b10;//tiret centre
	}
	else if(button == 2)//bouton up
	{
		return 0b11;//tiret droite
	}
	else if(button == 4)//bouton down
	{
		return 0b01;//tiret gauche
	}
	else
	{
		return 0;//aucun tiret
	}
}


//======================================================================================
//Entrer le score, allume les LEDs pour indiqué à quelle niveau nous somme
//et renvoi le temps de décalage des tirets en ms: niveau augement -> vitesse augmente
//======================================================================================
unsigned int time_level(unsigned int score)
{
	unsigned int appuie_button = 0;
	if (MemoryRead(BUTTONS_VALUES) > 0)
	{
		appuie_button = 1u << 4;
	}

	if(score < 20)
	{
		MemoryWrite(CTRL_SL_RW, (0b1)<<15 | appuie_button);//allume un led -> level 1
		return 1000; //1 seconde
	}
	else if(score < 40)
	{
		MemoryWrite(CTRL_SL_RW, (0b11)<<14 | appuie_button);//allume deux leds -> level 2
		return 900; //900 millisecondes
	}
	else if(score < 60)
	{
		MemoryWrite(CTRL_SL_RW, (0b111)<<13 | appuie_button);
		return 800;
	}
	else if(score < 80)
	{
		MemoryWrite(CTRL_SL_RW, (0b1111)<<12 | appuie_button);
		return 700;
	}
	else if(score < 100)
	{
		MemoryWrite(CTRL_SL_RW, (0b11111)<<11 | appuie_button);
		return 600;
	}
	else if(score < 120)
	{
		MemoryWrite(CTRL_SL_RW, (0b111111)<<10 | appuie_button);
		return 500;
	}
	else if(score < 140)
	{
		MemoryWrite(CTRL_SL_RW, (0b1111111)<<9 | appuie_button);
		return 400;
	}
	else
	{
		MemoryWrite(CTRL_SL_RW, (0b11111111)<<8 | appuie_button);
		return 300;
	}
}
