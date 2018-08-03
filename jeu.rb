# Complété par RetroMan en suivant les instructions de l'activité 

class Personne
  attr_accessor :nom, :points_de_vie, :en_vie

  def initialize(nom)
    @nom = nom
    @points_de_vie = 100
    @en_vie = true
  end

  def info
    # - Renvoie le nom et les points de vie si la personne est en vie
    # - Renvoie le nom et "vaincu" si la personne a été vaincue
	  if(@points_de_vie > 0) 
		   return "#{@nom} (#{@points_de_vie}/100 pv)"
	  else
		   @en_vie = false
		   return "#{@nom} (vaincu)"
	  end
  end

  def attaque(personne)
    # - Fait subir des dégats à la personne passée en paramètre
    # - Affiche ce qu'il s'est passé
    puts "#{@nom} attaque #{personne.nom}"

    if personne.en_vie
	     if(defined? @degats_bonus)
		      puts "#{@nom} profite de #{@degats_bonus} points de dégats bonus."
	     end
	     personne.subit_attaque(degats())
    else
      puts "#{personne.nom} a déjà été vaincu"
    end
  end

  def subit_attaque(degats_recus)
    # - Réduit les points de vie en fonction des dégats reçus
    # - Affiche ce qu'il s'est passé
    # - Détermine si la personne est toujours en_vie ou non
	  @points_de_vie = @points_de_vie - degats_recus
	
	  puts "#{@nom} subit #{degats_recus} points de dégâts"
	
	  if(@points_de_vie <= 0)
		   puts "#{@nom} a été vaincu !"
       @en_vie = false
	  end
  end
end

class Joueur < Personne
  attr_accessor :degats_bonus

  def initialize(nom)
    # Par défaut le joueur n'a pas de dégats bonus
    @degats_bonus = 0

    # Appelle le "initialize" de la classe mère (Personne)
    super(nom)
  end

  def degats
    # Calcule les dégats
	  degats = rand(0..20) + @degats_bonus
	  return degats
  end

  def soin
    # Gagner de la vie
    # Affiche ce qu'il s'est passé

    if(@points_de_vie < 100)
	     @points_de_vie += vie_restoration = 16

	     puts "#{@nom} a restauré #{vie_restoration} points de vie"
    else
       puts "Votre santé est déjà au MAXIMUM !"
    end
  end

  def ameliorer_degats
    # Augmente les dégats bonus
    # Affiche ce qu'il s'est passé
	  @degats_bonus += rand(10..30)
	  puts "#{@nom} gagne en puissance !"
  end
end

class Ennemi < Personne
  def degats
    # Calcule les dégats

	  degats = rand(0..10)
	  return degats
  end
end

class Jeu
  def self.actions_possibles(monde)
    puts "ACTIONS POSSIBLES :"

    puts "0 - Se soigner"
    puts "1 - Améliorer son attaque"

    # On commence à 2 car 0 et 1 sont réservés pour les actions
    # de soin et d'amélioration d'attaque
    i = 2
    monde.ennemis.each do |ennemi|
      puts "#{i} - Attaquer #{ennemi.info}"
      i = i + 1
    end
    puts "99 - Quitter"
  end

  def self.est_fini(joueur, monde)
    # Déterminer la condition de fin du jeu
	  i = 0
	  nbEnnemis = monde.ennemis.size
	
	  monde.ennemis.each do |ennemi|
		  if !ennemi.en_vie 
			  i = i + 1	
			  if i == nbEnnemis
				   return true
			  end
		  end
	  end
	
	  if joueur.en_vie == false 
		   return true
	  end
  end
end

class Monde
  attr_accessor :ennemis

  def ennemis_en_vie
    # Ne retourne que les ennemis en vie
	  tabEnnemis = []
	  @ennemis.each do |ennemi|
		   if ennemi.points_de_vie > 0
			   tabEnnemis << ennemi
		   end
	  end
	
	  return tabEnnemis
  end
end

##############

# Initialisation du monde
monde = Monde.new

# Ajout des ennemis
monde.ennemis = [
  Ennemi.new("Balrog"),
  Ennemi.new("Goblin"),
  Ennemi.new("Squelette")
]

# Initialisation du joueur
joueur = Joueur.new("Jean-Michel Paladin")

# Message d'introduction. \n signifie "retour à la ligne"
puts "\n\nAinsi débutent les aventures de #{joueur.nom}\n\n"

# Boucle de jeu principale
100.times do |tour|
  puts "\n------------------ Tour numéro #{tour} ------------------"

  # Affiche les différentes actions possibles
  Jeu.actions_possibles(monde)

  puts "\nQUELLE ACTION FAIRE ?"
  # On range dans la variable "choix" ce que l'utilisateur renseigne
  choix = gets.chomp.to_i

  # En fonction du choix on appelle différentes méthodes sur le joueur
  if choix == 0
    joueur.soin
  elsif choix == 1
    joueur.ameliorer_degats
  elsif choix == 99
    # On quitte la boucle de jeu si on a choisi
    # 99 qui veut dire "quitter"
    joueur.en_vie = "quitter"
    break
  else
    # Choix - 2 car nous avons commencé à compter à partir de 2
    # car les choix 0 et 1 étaient réservés pour le soin et
    # l'amélioration d'attaque
    ennemi_a_attaquer = monde.ennemis[choix - 2]
    joueur.attaque(ennemi_a_attaquer)
  end

  puts "\nLES ENNEMIS RIPOSTENT !"
  # Pour tous les ennemis en vie ...
  monde.ennemis_en_vie.each do |ennemi|
    # ... le héro subit une attaque.
    ennemi.attaque(joueur)
  end

  puts "\nEtat du héros : #{joueur.info}\n"

  # Si le jeu est fini, on interompt la boucle
  break if Jeu.est_fini(joueur, monde)
end

puts "\nFin de jeu\n"


# Affiche le résultat de la partie
if joueur.en_vie == true
  puts "Vous avez gagné !"
else
  if joueur.en_vie == false
    puts "Vous avez perdu !"
  else
    puts "Vous avez quitté la partie !"
  end
end




