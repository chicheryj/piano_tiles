---------------------------------------------------------------------
-- TITLE: Arithmetic Logic Unit
-- AUTHOR: Henri
-- DATE CREATED: 2/8/01
-- FILENAME: trans_hexto7seg.vhd
-- PROJECT: Plasma CPU core
-- COPYRIGHT: Software placed into the public domain by the author.
--    Software 'as is' without warranty.  Author liable for nothing.
-- DESCRIPTION:
--    Transcode 8 hexadecimal characters (32 bit input -> 8 hexa characters of
--    4 bits each) into 8 seven segment characters.
---------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity trans_tilesto7seg is
  Port ( input_mem : in STD_LOGIC_VECTOR (31 downto 0);
    e0 : out STD_LOGIC_VECTOR (6 downto 0);
    e1 : out STD_LOGIC_VECTOR (6 downto 0);
    e2 : out STD_LOGIC_VECTOR (6 downto 0);
    e3 : out STD_LOGIC_VECTOR (6 downto 0);
    e4 : out STD_LOGIC_VECTOR (6 downto 0);
    e5 : out STD_LOGIC_VECTOR (6 downto 0);
    e6 : out STD_LOGIC_VECTOR (6 downto 0);
    e7 : out STD_LOGIC_VECTOR (6 downto 0)
  );
end trans_tilesto7seg;

architecture Behavioral of trans_tilesto7seg is

  CONSTANT zero : STD_LOGIC_VECTOR (6 downto 0) := "1000000";
  CONSTANT one : STD_LOGIC_VECTOR (6 downto 0) := "1111001";
  CONSTANT two : STD_LOGIC_VECTOR (6 downto 0) := "0100100";
  CONSTANT three : STD_LOGIC_VECTOR (6 downto 0) := "0110000";
  CONSTANT four : STD_LOGIC_VECTOR (6 downto 0) := "0011001";
  CONSTANT five : STD_LOGIC_VECTOR (6 downto 0) := "0010010";
  CONSTANT six : STD_LOGIC_VECTOR (6 downto 0) := "0000010";
  CONSTANT seven : STD_LOGIC_VECTOR (6 downto 0) := "1111000";
  CONSTANT eight : STD_LOGIC_VECTOR (6 downto 0) := "0000000";
  CONSTANT nine : STD_LOGIC_VECTOR (6 downto 0) := "0010000";
  CONSTANT xA : STD_LOGIC_VECTOR (6 downto 0) := "0001000";
  CONSTANT xB : STD_LOGIC_VECTOR (6 downto 0) := "0000011";
  CONSTANT xC : STD_LOGIC_VECTOR (6 downto 0) := "1000110";
  CONSTANT xD : STD_LOGIC_VECTOR (6 downto 0) := "0100001";
  CONSTANT xE : STD_LOGIC_VECTOR (6 downto 0) := "0000110";
  CONSTANT xF : STD_LOGIC_VECTOR (6 downto 0) := "0001110";
  CONSTANT vide : STD_LOGIC_VECTOR (6 downto 0) := "1111111";
  CONSTANT gauche : STD_LOGIC_VECTOR (6 downto 0) := "1110111";
  CONSTANT centre : STD_LOGIC_VECTOR (6 downto 0) := "0111111";
  CONSTANT droite : STD_LOGIC_VECTOR (6 downto 0) := "1111110";
  CONSTANT xP : STD_LOGIC_VECTOR (6 downto 0) := "0001100";
  CONSTANT xU : STD_LOGIC_VECTOR (6 downto 0) := "1000001";
  CONSTANT xS : STD_LOGIC_VECTOR (6 downto 0) := "0010010";
  CONSTANT xH : STD_LOGIC_VECTOR (6 downto 0) := "0001001";
  CONSTANT xL : STD_LOGIC_VECTOR (6 downto 0) := "1000111";
  CONSTANT xO : STD_LOGIC_VECTOR (6 downto 0) := "1000000";

  signal etat_jeu : integer range 0 to 3 :=0;
  signal aff_0 : integer range 0 to 3 :=0;
  signal aff_1 : integer range 0 to 3 :=0;
  signal aff_2 : integer range 0 to 3 :=0;
  signal aff_3 : integer range 0 to 3 :=0;
  signal aff_4 : integer range 0 to 3 :=0;
  signal aff_5 : integer range 0 to 3 :=0;
  signal aff_6 : integer range 0 to 3 :=0;
  signal aff_7 : integer range 0 to 3 :=0;
  SIGNAL score: STD_LOGIC_VECTOR (11 downto 0);
begin


  aff_0 <= to_integer( unsigned( input_mem( 1 downto 0 ) ) );
  aff_1 <= to_integer( unsigned( input_mem( 3 downto 2 ) ) );
  aff_2 <= to_integer( unsigned( input_mem( 5 downto 4 ) ) );
  aff_3 <= to_integer( unsigned( input_mem( 7 downto 6 ) ) );
  aff_4 <= to_integer( unsigned( input_mem( 9 downto 8 ) ) );
  aff_5 <= to_integer( unsigned( input_mem( 11 downto 10 ) ) );
  aff_6 <= to_integer( unsigned( input_mem( 13 downto 12 ) ) );
  aff_7 <= to_integer( unsigned( input_mem( 15 downto 14 ) ) );
  etat_jeu <= to_integer( unsigned( input_mem( 17 downto 16 ) ) );
  score <= input_mem( 31 downto 20  );

  process(etat_jeu, aff_0, aff_1, aff_2, aff_3, aff_4, aff_5, aff_6, aff_7)
  variable nbre_binaire, nbre_binaire_reste_diz, nbre_binaire_reste_uni : unsigned (11 downto 0);
  begin

	  if(etat_jeu = 0) then
	  	e7 <= vide;
	  	e6 <= vide;
	  	e5 <= vide;
	  	e4 <= vide;
	  	e3 <= xH;
	  	e2 <= xS;
	  	e1 <= xU;
	  	e0 <= xP;

	  elsif(etat_jeu = 1) then

	  	case aff_0 is
	  	when 0 => e7 <= vide;
	  	when 1 => e7 <= gauche;
	  	when 2 => e7 <= centre;
	  	when 3 => e7 <= droite;
	  	when others => e7 <= vide;
	  	end case;

	  	case aff_1 is
	  	when 0 => e6 <= vide;
	  	when 1 => e6 <= gauche;
	  	when 2 => e6 <= centre;
	  	when 3 => e6 <= droite;
	  	when others => e6 <= vide;
	  	end case;

	  	case aff_2 is
	  	when 0 => e5 <= vide;
	  	when 1 => e5 <= gauche;
	  	when 2 => e5 <= centre;
	  	when 3 => e5 <= droite;
	  	when others => e5 <= vide;
	  	end case;

	  	case aff_3 is
	  	when 0 => e4 <= vide;
	  	when 1 => e4 <= gauche;
	  	when 2 => e4 <= centre;
	  	when 3 => e4 <= droite;
	  	when others => e4 <= vide;
	  	end case;

	  	case aff_4 is
	  	when 0 => e3 <= vide;
	  	when 1 => e3 <= gauche;
	  	when 2 => e3 <= centre;
	  	when 3 => e3 <= droite;
	  	when others => e3 <= vide;
	  	end case;

	  	case aff_5 is
	  	when 0 => e2 <= vide;
	  	when 1 => e2 <= gauche;
	  	when 2 => e2 <= centre;
	  	when 3 => e2 <= droite;
	  	when others => e2 <= vide;
	  	end case;

	  	case aff_6 is
	  	when 0 => e1 <= vide;
	  	when 1 => e1 <= gauche;
	  	when 2 => e1 <= centre;
	  	when 3 => e1 <= droite;
	  	when others => e1 <= vide;
	  	end case;

	  	case aff_7 is
	  	when 0 => e0 <= vide;
	  	when 1 => e0 <= gauche;
	  	when 2 => e0 <= centre;
	  	when 3 => e0 <= droite;
	  	when others => e0 <= vide;
	  	end case;

	  elsif(etat_jeu = 2) then

        nbre_binaire := unsigned( score ); --rel�ve le score en cas de d�faite

	  	e0 <= xL;
	  	e1 <= xO;
	  	e2 <= xS;
	  	e3 <= xE;

    --DETERMINATION DES CENTAINES
            if nbre_binaire < to_unsigned(100,12) then
                e5 <= zero;
                nbre_binaire_reste_diz := nbre_binaire;

            elsif nbre_binaire < to_unsigned(200,12) then
                e5 <= one;
                nbre_binaire_reste_diz := nbre_binaire - to_unsigned(100,12);

            elsif nbre_binaire < to_unsigned(300,12) then
                e5 <= two;
                nbre_binaire_reste_diz := nbre_binaire - to_unsigned(200,12);

            elsif nbre_binaire < to_unsigned(400,12) then
                e5 <= three;
                nbre_binaire_reste_diz := nbre_binaire - to_unsigned(300,12);

            elsif nbre_binaire < to_unsigned(500,12) then
                e5 <= four;
                nbre_binaire_reste_diz := nbre_binaire - to_unsigned(400,12);

            elsif nbre_binaire < to_unsigned(600,12) then
                e5 <= five;
                nbre_binaire_reste_diz := nbre_binaire - to_unsigned(500,12);

            elsif nbre_binaire < to_unsigned(700,12) then
                e5 <= six;
                nbre_binaire_reste_diz := nbre_binaire - to_unsigned(600,12);

            elsif nbre_binaire < to_unsigned(800,12) then
                e5 <= seven;
                nbre_binaire_reste_diz := nbre_binaire - to_unsigned(700,12);

            elsif nbre_binaire < to_unsigned(900,12) then
                e5 <= eight;
                nbre_binaire_reste_diz := nbre_binaire - to_unsigned(800,12);

            elsif nbre_binaire < to_unsigned(1000,12) then
                e5 <= nine;
                nbre_binaire_reste_diz := nbre_binaire - to_unsigned(900,12);

            else
                e5 <= nine;
                nbre_binaire_reste_diz := to_unsigned(99,12);

            end if;

    --DETERMINATION DES DIZAINES
            if nbre_binaire_reste_diz < to_unsigned(10,12) then
                e6 <= zero;
                nbre_binaire_reste_uni := nbre_binaire_reste_diz;

            elsif nbre_binaire_reste_diz < to_unsigned(20,12) then
                e6 <= one;
                nbre_binaire_reste_uni := nbre_binaire_reste_diz - to_unsigned(10,12);

            elsif nbre_binaire_reste_diz < to_unsigned(30,12) then
                e6 <= two;
                nbre_binaire_reste_uni := nbre_binaire_reste_diz - to_unsigned(20,12);

            elsif nbre_binaire_reste_diz < to_unsigned(40,12) then
                e6 <= three;
                nbre_binaire_reste_uni := nbre_binaire_reste_diz - to_unsigned(30,12);

            elsif nbre_binaire_reste_diz < to_unsigned(50,12) then
                e6 <= four;
                nbre_binaire_reste_uni := nbre_binaire_reste_diz - to_unsigned(40,12);

            elsif nbre_binaire_reste_diz < to_unsigned(60,12) then
                e6 <= five;
                nbre_binaire_reste_uni := nbre_binaire_reste_diz - to_unsigned(50,12);

            elsif nbre_binaire_reste_diz < to_unsigned(70,12) then
                e6 <= six;
                nbre_binaire_reste_uni := nbre_binaire_reste_diz - to_unsigned(60,12);

            elsif nbre_binaire_reste_diz < to_unsigned(80,12) then
                e6 <= seven;
                nbre_binaire_reste_uni := nbre_binaire_reste_diz - to_unsigned(70,12);

            elsif nbre_binaire_reste_diz < to_unsigned(90,12) then
                e6 <= eight;
                nbre_binaire_reste_uni := nbre_binaire_reste_diz - to_unsigned(80,12);

            else
                e6 <= nine;
                nbre_binaire_reste_uni := nbre_binaire_reste_diz - to_unsigned(90,12);

            end if;

    --DETERMINATION DES UNITEES
            case nbre_binaire_reste_uni is
                 when to_unsigned(0,12) => e7 <= zero;
                 when to_unsigned(1,12) => e7 <= one;
                 when to_unsigned(2,12) => e7 <= two;
                 when to_unsigned(3,12) => e7 <= three;
                 when to_unsigned(4,12) => e7 <= four;
                 when to_unsigned(5,12) => e7 <= five;
                 when to_unsigned(6,12) => e7 <= six;
                 when to_unsigned(7,12) => e7 <= seven;
                 when to_unsigned(8,12) => e7 <= eight;
                 when others => e7 <= nine;
            end case;
	  else
	  	e7 <= vide;
	  	e6 <= vide;
	  	e5 <= vide;
	  	e4 <= vide;
	  	e3 <= vide;
	  	e2 <= vide;
	  	e1 <= vide;
	  	e0 <= vide;

	  end if;

  end process;

end Behavioral;
