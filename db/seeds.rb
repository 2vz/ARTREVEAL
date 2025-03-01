User.destroy_all
Workart.destroy_all
UserWorkart.destroy_all

require 'faker'

# USERS : 5
5.times do |i|
  puts "Creating user #{i + 1}"

  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = "#{first_name.downcase}.#{last_name.downcase}@example.com"
  pseudo = "#{first_name.downcase}_#{last_name.downcase}"

  file = File.open(Rails.root.join("app/assets/images/pdp#{i + 1}.jpg"))

  user = User.new(
    first_name: first_name,
    last_name: last_name,
    email: email,
    password: "password123",
    pseudo: pseudo
  )

  user.photo.attach(io: file, filename: "avatar.png", content_type: "image/jpg")
  user.save
end

# WORKART : 10
  workarts = [
    {
      primary_artist: "Léonard de Vinci",
      workart_title: "La Joconde",
      description_short: "Un portrait emblématique de la Renaissance, célèbre pour son sourire énigmatique.",
      description_middle: "Peint par Léonard de Vinci, cette œuvre est reconnue pour son sfumato et son regard captivant. Elle représente une femme, souvent identifiée comme Lisa Gherardini.",
      description_long: "La Joconde, ou Mona Lisa, est un portrait réalisé par Léonard de Vinci entre 1503 et 1519. Il s'agit d'une peinture à l'huile sur panneau de bois de peuplier, mesurant 77 × 53 cm. Son expression, souvent qualifiée d’énigmatique, et son regard qui semble suivre le spectateur sont parmi les caractéristiques qui en font l’un des tableaux les plus célèbres au monde. Le sfumato, technique utilisée par Vinci, confère à son visage une douceur et une transition subtile entre les ombres et les lumières.",
      image_url: "https://upload.wikimedia.org/wikipedia/commons/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg"
    },
    {
      primary_artist: "Vincent van Gogh",
      workart_title: "La Nuit étoilée",
      description_short: "Un paysage nocturne vibrant aux couleurs tourbillonnantes.",
      description_middle: "Peint en 1889 par Vincent van Gogh, La Nuit étoilée est une représentation du ciel nocturne depuis sa chambre à l'asile de Saint-Rémy.",
      description_long: "Cette peinture est réalisée alors que Van Gogh était interné volontairement dans un asile à Saint-Rémy-de-Provence. Elle représente un village sous un ciel mouvementé, avec des étoiles lumineuses et une lune éclatante. Le style expressif et les coups de pinceau tourbillonnants confèrent une dynamique unique à cette œuvre.",
      image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/VanGogh-starry_night_ballance1.jpg/640px-VanGogh-starry_night_ballance1.jpg"
    },
    {
      primary_artist: "Edvard Munch",
      workart_title: "Le Cri",
      description_short: "Un visage terrifié sous un ciel rougeoyant, symbole d'angoisse existentielle.",
      description_middle: "Réalisé en 1893, Le Cri d’Edvard Munch représente une silhouette en proie à une angoisse profonde, avec un ciel rouge sang.",
      description_long: "Cette œuvre emblématique de l'expressionnisme illustre une figure hurlante sur un pont, tandis que l’arrière-plan tourmenté reflète une forte tension émotionnelle. Inspiré par une expérience personnelle de Munch où il ressentit un cri infini traverser la nature, le tableau est devenu un symbole universel de l'anxiété humaine.",
      image_url: "https://upload.wikimedia.org/wikipedia/commons/f/f4/The_Scream.jpg"
    },
    {
      primary_artist: "Pablo Picasso",
      workart_title: "Guernica",
      description_short: "Un chef-d'œuvre du cubisme dénonçant les horreurs de la guerre.",
      description_middle: "Peinte en 1937, Guernica est une réaction au bombardement de la ville basque du même nom pendant la guerre civile espagnole.",
      description_long: "Guernica est une immense peinture en noir et blanc de Pablo Picasso, réalisée en réponse au bombardement de la ville de Guernica par l'aviation nazie. L’œuvre, qui mélange des formes cubistes et surréalistes, exprime la douleur et la souffrance des victimes à travers des figures distordues.",
      image_url: "https://upload.wikimedia.org/wikipedia/en/7/74/PicassoGuernica.jpg"
    },
    {
      primary_artist: "Claude Monet",
      workart_title: "Impression, Soleil Levant",
      description_short: "Le tableau qui a donné son nom au mouvement impressionniste.",
      description_middle: "Peint en 1872, ce paysage marin matinal est une ode à la lumière et à la couleur, capturant l’instantanéité d’un lever de soleil sur Le Havre.",
      description_long: "Ce chef-d'œuvre de Claude Monet représente un port au lever du soleil, avec des touches de pinceau rapides et floues qui donnent une sensation de mouvement et de spontanéité. L’œuvre fut exposée en 1874 lors de la première exposition impressionniste et donna son nom au mouvement.",
      image_url: "https://upload.wikimedia.org/wikipedia/commons/5/5c/Claude_Monet%2C_Impression%2C_soleil_levant%2C_1872.jpg?20120111170102"
    },
    {
      primary_artist: "Johannes Vermeer",
      workart_title: "La Jeune Fille à la perle",
      description_short: "Un portrait mystérieux d'une jeune fille portant une perle.",
      description_middle: "L'œuvre de Vermeer, peinte vers 1665, est l'une des plus célèbres du baroque hollandais. La jeune fille semble tourner sa tête vers le spectateur, portant une perle et une coiffe exotique.",
      description_long: "Ce portrait iconique de Vermeer représente une jeune fille portant une perle comme pendentif, un turban bleu et un regard captivant. Le jeu de lumière et l'utilisation du bleu et de l'ocre rendent cette œuvre unique et intemporelle. Elle est souvent comparée à La Joconde en raison de l'expression fascinante du modèle et de la simplicité de la composition.",
      image_url: "https://upload.wikimedia.org/wikipedia/commons/d/d7/Meisje_met_de_parel.jpg"
    },
    {
      primary_artist: "Leonardo da Vinci",
      workart_title: "L'Homme de Vitruve",
      description_short: "Un dessin représentant les proportions idéales du corps humain.",
      description_middle: "Ce célèbre dessin de Léonard de Vinci, daté vers 1490, illustre les proportions du corps humain, selon les principes de l'architecte Vitruve.",
      description_long: "L'Homme de Vitruve est un dessin qui représente les idéaux des proportions humaines établis par l'architecte romain Vitruve. Ce croquis montre un homme nu dans deux positions superposées, avec les bras et les jambes écartés. Il est souvent utilisé comme une référence à l’union de l’art et des sciences chez Léonard de Vinci.",
      image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/Da_Vinci_Vitruve_Luc_Viatour.jpg/882px-Da_Vinci_Vitruve_Luc_Viatour.jpg?20100914054557"
    },
    {
      primary_artist: "Gustav Klimt",
      workart_title: "Le Baiser",
      description_short: "Un tableau romantique représentant un couple enlacé.",
      description_middle: "Peint en 1907-1908, Le Baiser est l'une des œuvres les plus célèbres de Klimt, représentant un couple dans une étreinte passionnée.",
      description_long: "Le Baiser est un exemple emblématique de l'Art Nouveau et du style doré de Klimt. Ce tableau montre un couple dans une étreinte passionnée, avec un fond doré et orné de motifs géométriques. L'utilisation de l'or et la sensualité du couple font de cette œuvre un symbole de l’amour et de la beauté.",
      image_url: "https://upload.wikimedia.org/wikipedia/commons/f/f3/Gustav_Klimt_016.jpg?20120409065933"
    },
    {
      primary_artist: "Michel-Ange",
      workart_title: "La Création d'Adam",
      description_short: "Une fresque représentant Dieu donnant la vie à Adam.",
      description_middle: "Peinte entre 1511 et 1512, cette fresque fait partie du plafond de la chapelle Sixtine au Vatican, illustrant le moment où Dieu touche le doigt d'Adam pour lui donner la vie.",
      description_long: "La Création d'Adam est l'une des fresques les plus célèbres de Michel-Ange, représentant le moment biblique où Dieu donne la vie à Adam. Cette œuvre incarne la vision de l’artiste du divin, avec des figures sculpturales et une composition grandiose qui a marqué l’histoire de l'art occidental.",
      image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/%27Adam%27s_Creation_Sistine_Chapel_ceiling%27_by_Michelangelo_JBU33cut.jpg/640px-%27Adam%27s_Creation_Sistine_Chapel_ceiling%27_by_Michelangelo_JBU33cut.jpg"
    },
    {
      primary_artist: "Salvador Dalí",
      workart_title: "La Persistance de la mémoire",
      description_short: "Une œuvre surréaliste célèbre pour ses montres fondantes.",
      description_middle: "Peinte en 1931, cette œuvre de Dalí représente des montres fondantes dans un paysage désertique, exprimant l'idée que le temps est relatif.",
      description_long: "La Persistance de la mémoire est un tableau surréaliste de Salvador Dalí, où des montres fondent sur des objets dans un paysage désertique. Ce tableau est souvent interprété comme une réflexion sur la fluidité du temps et sur la manière dont l'esprit humain perçoit la réalité.",
      image_url: "https://upload.wikimedia.org/wikipedia/en/d/dd/The_Persistence_of_Memory.jpg"
    }
  ].map { |attrs| Workart.create!(attrs) }

# USER_WORKART
User.all.each do |user|
  workarts.each do |workart|
    puts "Associating workarts to users"
    UserWorkart.create!(
      user:,
      workart:,
      liked: [true, false].sample
    )
  end
end
