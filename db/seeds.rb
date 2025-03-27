User.destroy_all
Workart.destroy_all
UserWorkart.destroy_all

require 'faker'

# USERS : 100
100.times do |i|
  puts "Creating user #{i + 1}"

  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = "#{first_name.downcase}.#{last_name.downcase}@example.com"
  pseudo = "#{first_name.downcase}_#{last_name.downcase}"

  avatar_number = rand(1..5)
  file = File.open(Rails.root.join("app/assets/images/pdp#{avatar_number}.jpg"))

  user = User.new(
    first_name: first_name,
    last_name: last_name,
    email: email,
    password: "password123",
    pseudo: pseudo
  )

  user.photo.attach(io: file, filename: "pdp#{avatar_number}.jpg", content_type: "image/jpg")
  user.save
end

# WORKART : 10
workarts = [
  {
    primary_artist: "Leonardo da Vinci",
    workart_title: "Mona Lisa",
    description_short: "Leonardo da Vinci's iconic Renaissance portrait from 1503-1519, renowned for its enigmatic smile and groundbreaking sfumato technique that revolutionized portrait painting with its subtle gradations of light and shadow.",
    description_middle: "Created between 1503 and 1519, the Mona Lisa represents a pinnacle of Renaissance art. Da Vinci's masterful use of sfumato—a technique of soft, blurred transitions between colors and tones—brings an unprecedented depth and mystery to this portrait of a woman with an ambiguous, captivating expression.",
    description_long: "The Mona Lisa, or La Gioconda, is a testament to Leonardo da Vinci's unparalleled artistic genius. Painted on a poplar wood panel measuring 77 × 53 cm, this artwork has captivated viewers for centuries. Its subject, believed to be Lisa Gherardini, is depicted with an innovative approach that breaks from traditional portraiture, creating an intimate yet enigmatic representation of human complexity.",
    image_url: "https://upload.wikimedia.org/wikipedia/commons/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg",
    address: "Louvre Museum, 75001 Paris, France"
  },
  {
    primary_artist: "Vincent van Gogh",
    workart_title: "The Starry Night",
    description_short: "Vincent van Gogh's 1889 masterpiece depicting a turbulent night sky with swirling clouds and brilliant stars, created during his time at the Saint-Paul-de-Mausole asylum, embodying the raw emotional intensity of Post-Impressionist art.",
    description_middle: "Painted in 1889 while voluntarily institutionalized in Saint-Rémy-de-Provence, The Starry Night is a profound expression of Van Gogh's inner emotional landscape. The painting transforms a nocturnal landscape into a dynamic, almost living composition, with powerful brushstrokes that convey movement, emotion, and psychological depth.",
    description_long: "The Starry Night emerges from a deeply personal moment in Van Gogh's life, created during his stay at the Saint-Paul-de-Mausole asylum. The painting transcends mere landscape, becoming a powerful visualization of the artist's inner turmoil and unique perception of the world. Bold, swirling brushstrokes and vibrant colors create a sense of cosmic energy and emotional intensity.",
    image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/VanGogh-starry_night_ballance1.jpg/640px-VanGogh-starry_night_ballance1.jpg",
    address: "Museum of Modern Art, 11 W 53rd St, New York, NY 10019, United States"
  },
  {
    primary_artist: "Edvard Munch",
    workart_title: "The Scream",
    description_short: "Edvard Munch's 1893 expressionist masterpiece capturing profound human anxiety, featuring a distorted figure against a blood-red sky, symbolizing existential dread and psychological turbulence of the modern human condition.",
    description_middle: "Created in 1893, The Scream is a revolutionary artwork that transcends traditional representation. Munch's innovative composition and use of vivid, unsettling colors capture a moment of extreme psychological tension. The undulating landscape and distorted figure embody the inner emotional landscape of anxiety and existential fear.",
    description_long: "The Scream represents a pivotal moment in art history, where internal psychological states become the primary subject. Munch's figure, with its elongated, sexless form, stands on a bridge with a tumultuous, blood-red sky behind it. The painting is less a literal scene and more a visceral representation of modern human anxiety, isolation, and the overwhelming sensations of existential dread.",
    image_url: "https://upload.wikimedia.org/wikipedia/commons/f/f4/The_Scream.jpg",
    address: "National Gallery of Norway, Edvard Munchs Plass 1, 0194 Oslo, Norway"
  },
  {
    primary_artist: "Pablo Picasso",
    workart_title: "Guernica",
    description_short: "Pablo Picasso's monumental 1937 anti-war masterpiece in black and white, depicting the brutal bombing of Guernica during the Spanish Civil War, a powerful cubist condemnation of military violence and human suffering.",
    description_middle: "Painted in response to the Nazi bombing of Guernica in 1937, this massive black and white artwork is a profound political statement. Picasso's cubist style fragments and distorts figures, creating a chaotic, heart-wrenching representation of war's devastating impact on civilian populations and the broader human experience.",
    description_long: "Guernica stands as one of the most powerful anti-war statements in art history. Commissioned for the 1937 Paris World's Fair, the painting emerged directly from the shocking bombing of the Basque town of Guernica by Nazi German and Fascist Italian warplanes during the Spanish Civil War. Picasso's monochromatic palette amplifies the stark, brutal reality of military violence.",
    image_url: "https://upload.wikimedia.org/wikipedia/en/7/74/PicassoGuernica.jpg",
    address: "Museo Reina Sofía, C. de Sta. Isabel, 52, Centro, 28012 Madrid, Spain"
  },
  {
    primary_artist: "Claude Monet",
    workart_title: "Impression, Sunrise",
    description_short: "Claude Monet's revolutionary 1872 maritime landscape that gave name to the Impressionist movement, capturing the ephemeral play of light and color in a harbor at dawn with loose, innovative brushwork.",
    description_middle: "Painted in 1872, this groundbreaking artwork represents a pivotal moment in art history. Monet's radical approach to capturing light and atmosphere, using quick, visible brushstrokes and a vibrant color palette, challenged traditional painting techniques and laid the foundation for the Impressionist movement.",
    description_long: "Impression, Sunrise is more than a painting—it's a manifesto of artistic revolution. Depicting the port of Le Havre at sunrise, Monet broke from academic painting traditions by prioritizing the artist's perceptual experience over detailed representation. The painting's loose brushwork and emphasis on atmospheric effects would inspire an entire generation of artists.",
    image_url: "https://upload.wikimedia.org/wikipedia/commons/5/5c/Claude_Monet%2C_Impression%2C_soleil_levant%2C_1872.jpg",
    address: "Musée Marmottan Monet, 2 Rue Louis Boilly, 75016 Paris, France"
  },
  {
    primary_artist: "Johannes Vermeer",
    workart_title: "Girl with a Pearl Earring",
    description_short: "Johannes Vermeer's enigmatic c. 1665 masterpiece, a Dutch Baroque portrait capturing a young woman with a luminous pearl earring, renowned for its exquisite use of light, color, and psychological depth.",
    description_middle: "Created around 1665, this iconic painting exemplifies Vermeer's extraordinary skill in capturing light and human emotion. The subject, wearing a blue turban and a stunning pearl earring, gazes directly at the viewer with an expression that is at once intimate and mysterious, revealing Vermeer's mastery of psychological portraiture.",
    description_long: "Often called the 'Mona Lisa of the North', Girl with a Pearl Earring transcends typical portraiture. Vermeer transforms an ordinary moment into a timeless meditation on beauty, light, and human presence. The painting's subtle color palette, the soft illumination falling on the subject's face, and her direct yet ambiguous gaze create an enduring sense of wonder and intrigue.",
    image_url: "https://upload.wikimedia.org/wikipedia/commons/d/d7/Meisje_met_de_parel.jpg",
    address: "Mauritshuis Museum, Plein 29, 2511 CS Den Haag, Netherlands"
  },
  {
    primary_artist: "Leonardo da Vinci",
    workart_title: "Vitruvian Man",
    description_short: "Leonardo da Vinci's iconic c. 1490 drawing illustrating the ideal human body proportions, blending art, science, and philosophy in a single, revolutionary image that symbolizes Renaissance humanist ideals.",
    description_middle: "Created around 1490, the Vitruvian Man is a remarkable synthesis of artistic observation and scientific precision. Based on the writings of the Roman architect Vitruve, da Vinci's drawing explores the mathematical proportions of the human body, positioning man at the center of the universe and reflecting the Renaissance's holistic view of human potential.",
    description_long: "The Vitruvian Man represents the pinnacle of Renaissance thought, where art, science, and philosophy converge. Da Vinci's drawing is not merely an anatomical study but a profound philosophical statement about human potential and cosmic harmony. By inscribing a human figure within a circle and square, he visualizes the idea that human beings are a microcosm of the universe.",
    image_url: "https://upload.wikimedia.org/wikipedia/commons/2/22/Da_Vinci_Vitruve_Luc_Viatour.jpg",
    address: "Gallerie dell'Accademia, Calle della Carità, 1050, 30123 Venice, Italy"
  },
  {
    primary_artist: "Gustav Klimt",
    workart_title: "The Kiss",
    description_short: "Gustav Klimt's 1907-1908 masterpiece of Art Nouveau, depicting an intimate, golden-clad couple in a passionate embrace, symbolizing love, sensuality, and the decorative elegance of the early 20th-century artistic movement.",
    description_middle: "Painted between 1907 and 1908, The Kiss represents the zenith of Klimt's 'Golden Period'. The artwork blends figurative representation with intricate, decorative patterns, creating a mesmerizing visualization of romantic love. The couple's bodies are adorned with elaborate gold leaf and geometric designs, symbolizing unity and transcendence.",
    description_long: "The Kiss is a testament to Klimt's revolutionary artistic vision. Set against a backdrop of shimmering gold and intricate geometric patterns, the painting transforms a simple romantic moment into a cosmic, almost spiritual experience. The lovers are simultaneously individual and merged, their bodies decorated with ornate, symbolic designs that reflect the complex emotional and aesthetic landscape of early 20th-century Vienna.",
    image_url: "https://upload.wikimedia.org/wikipedia/commons/f/f3/Gustav_Klimt_016.jpg",
    address: "Österreichische Galerie Belvedere, Prinz-Eugen-Straße 27, 1030 Vienna, Austria"
  },
  {
    primary_artist: "Michelangelo",
    workart_title: "The Creation of Adam",
    description_short: "Michelangelo's iconic 1511-1512 fresco on the Sistine Chapel ceiling, depicting the biblical moment of God giving life to Adam, a masterpiece of Renaissance art that symbolizes divine creation and human potential.",
    description_middle: "Created between 1511 and 1512 as part of the Sistine Chapel ceiling, this fresco is a pinnacle of Renaissance artistic achievement. Michelangelo's extraordinary anatomical precision and dramatic composition capture the profound theological moment of divine creation, with God and Adam's fingers nearly touching in a powerful, symbolic gesture.",
    description_long: "The Creation of Adam transcends mere religious illustration, becoming a philosophical statement about human nature and divine potential. Michelangelo's genius lies in transforming a biblical narrative into a universal statement about the relationship between humanity and the divine. The tension between the almost-touching fingers of God and Adam represents the spark of life, creativity, and human potential.",
    image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Creaci%C3%B3n_de_Ad%C3%A1n.jpg/1599px-Creaci%C3%B3n_de_Ad%C3%A1n.jpg",
    address: "Sistine Chapel, 00120 Vatican City, Vatican City State"
  },
  {
    primary_artist: "Salvador Dali",
    workart_title: "The Persistence of Memory",
    description_short: "Salvador Dali's 1931 surrealist masterpiece featuring melting clocks in a dreamlike desert landscape, challenging perceptions of time, reality, and the subconscious through bizarre, fluid imagery.",
    description_middle: "Painted in 1931, this iconic surrealist work defies conventional understanding of time and space. Dali's soft, melting clocks draped across a barren landscape create a dreamlike scenario that challenges viewers' perceptions. The painting explores the fluidity of time, memory, and the strange logic of the subconscious mind.",
    description_long: "The Persistence of Memory is a quintessential surrealist artwork that deconstructs our understanding of reality. Dali's melting clocks, seemingly draped like soft cheese over a desolate landscape, symbolize the arbitrary and malleable nature of time. The painting invites viewers into a psychological space where linear time dissolves, and the boundaries between dream and reality become beautifully, disturbingly blurred.",
    image_url: "https://upload.wikimedia.org/wikipedia/en/d/dd/The_Persistence_of_Memory.jpg",
    address: "Museum of Modern Art, 11 W 53rd St, New York, NY 10019, United States"
  }
].map { |attrs| Workart.create!(attrs) }

# USER_WORKART
User.all.each do |user|

  num_likes = rand(3..8)


  random_workarts = workarts.shuffle.take(num_likes)

  random_workarts.each do |workart|
    puts "Associating workart to user with like"
    UserWorkart.create!(
      user:,
      workart:,
      liked: true
    )
  end
end
