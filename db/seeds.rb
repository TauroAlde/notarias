# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# TODO: move all the users creation to this file and iterate to create
permissions = YAML.load_file(File.join(Rails.root, "db", "permissions.yml"))
permissions.each do |roles_key, role_value|
  role_value.each do |users_key, users_array|
    users_array.each do |user_hash|
      current_user = User.create(user_hash)
      if roles_key == "common"
        current_user.roles << Role.common
      elsif roles_key == "admin"
        current_user.roles << Role.admin
      elsif roles_key == "super_admin"
        current_user.roles << Role.super_admin
      end
    end
  end
end

segments = YAML.load_file(File.join(Rails.root, "db", "segments.yml"))

@districts = District.create([
  { district_number: 1 },
  { district_number: 2 },
  { district_number: 3 }
])

def load_segments(segments_array, parent_segment = nil)
  segments_array.each do |segment_hash|
    puts "creating #{segment_hash["name"]} segment"
    child_segment = Segment.create(name: segment_hash["name"], district: District.find_by(district_number: segment_hash["district"]) )
    parent_segment.children << child_segment if parent_segment
    
    if segment_hash["children"]
      load_segments(segment_hash["children"], child_segment)
    end
  end
end

load_segments(segments)

candidacies = Candidacy.create([
  { name: Candidacy::PRESIDENCIA },
  { name: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: Candidacy::DIPUTADO_FEDERAL_D1 },
  { name: Candidacy::DIPUTADO_FEDERAL_D2 },
  { name: Candidacy::DIPUTADO_FEDERAL_D3 },
  { name: Candidacy::DIPUTADO_FEDERAL_D4 },
  { name: Candidacy::SENADOR }
])
PoliticalParty.create([
  { name: 'PVEM', full_name: 'Partido Verde Ecologista de México'  },
  { name: 'PRI', full_name: 'Partido Revolucionario Institucional'  },
  { name: 'PAN', full_name: 'Partido Acción Nacional'  },
  { name: 'PRD', full_name: 'Partido de la Revolución Democrática'  },
  { name: 'Morena', full_name: 'Movimiento Regeneracion Nacional' },
  { name: 'PANAL', full_name: 'Partido Nueva Alianza'  },
  { name: 'PT', full_name: 'Partido del Trabajo'  },
  { name: 'MC', full_name: 'Movimiento Ciudadano'  },
  { name: 'PES', full_name: 'Partido Encuentro Social' },
  { name: 'Independiente', full_name: 'Independiente'  }
])

[
  { names: ['PRD', 'PAN', 'MC'], name: 'PRD/PAN/MC' },
  { names: ['PRD', 'PAN'], name: 'PRD/PAN' },
  { names: ['PRI', 'PVEM', 'PANAL'], name: 'PRI/PVEM/PANAL' },
  { names: ['PVEM', 'PRI'], name: 'PVEM/PRI' },
  { names: ['Morena', 'PES', 'PT'], name: 'Morena/PES/PT' }
].each do |coalition|
  puts "creating coalition #{coalition[:name]}"
  coalition_ids = coalition[:names].map do |political_party|
    PoliticalParty.find_by(name: political_party).id
  end
  political_party = PoliticalParty.new(name: coalition[:name], coalition: true)
  political_party.parties_ids = coalition_ids
  political_party.save!
end

pri_pvem_panal_candidates = [
  { name: "Susana Hurtado Vallejo", main_political_party: 'PANAL', candidacy: Candidacy::SENADOR },
  { name: "Raymundo King de la Rosa", main_political_party: 'PRI', candidacy: Candidacy::SENADOR },
  { name: "Leslie Hendricks Rubio", main_political_party: 'PRI', candidacy: Candidacy::DIPUTADO_FEDERAL_D1 },
  { name: "Cora Amalia Castilla Madrid", main_political_party: 'PRI', candidacy: Candidacy::DIPUTADO_FEDERAL_D2 },
  { name: "Ana Patricia Peralta De la Peña", main_political_party: 'PVEM', candidacy: Candidacy::DIPUTADO_FEDERAL_D3 },
  { name: "Elda Candelaria Ayuso Achach", main_political_party: 'PRI', candidacy: Candidacy::DIPUTADO_FEDERAL_D4 },
  { name: "María Hadad Castillo", main_political_party: 'PRI', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Paoly Elizabeth Perera Maldonado", main_political_party: 'PRI', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Pedro Oscar Joaquin Delbouis", main_political_party: 'PRI', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Fabiola Ileana Cervera Vidal", main_political_party: 'PANAL', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Mario Machuca Sánchez", main_political_party: 'PVEM', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Martin De la Cruz Gómez", main_political_party: 'PRI', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Marciano Dzul Caamal", main_political_party: 'PRI', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Manuel Alexander Zetina Aguiluz", main_political_party: 'PANAL', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Laura Lynn Fernandez Piña", main_political_party: 'PVEM', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
]

pan_prd_mc_candidates = [
  { name: "Julián Ricalde", main_political_party: 'PRD', candidacy: Candidacy::SENADOR },
  { name: "Mayuli Latifa Martínez Simón", main_political_party: 'PAN', candidacy: Candidacy::SENADOR },
  { name: "Miguel Ramón Martín Azueta", main_political_party: 'MC', candidacy: Candidacy::DIPUTADO_FEDERAL_D1 },
  { name: "Luis Torres Llanes", main_political_party: 'PAN', candidacy: Candidacy::DIPUTADO_FEDERAL_D2 },
  { name: "Karla Romero Gómez", main_political_party: 'PRD', candidacy: Candidacy::DIPUTADO_FEDERAL_D3 },
  { name: "Gabriela López Pallares", main_political_party: 'PRD', candidacy: Candidacy::DIPUTADO_FEDERAL_D4 },
  { name: "Fernando Zelaya Espinoza", main_political_party: 'PAN', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "José Esquivel Vargas", main_political_party: 'PRD', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Sofía Alcocer Alcocer", main_political_party: 'PRD', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Perla Tun Pech", main_political_party: 'PAN', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "María Trinidad García Argüelles", main_political_party: 'PAN', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Faustino Uicab Alcocer", main_political_party: 'PAN', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Cristina Torres Gómez", main_political_party: 'PAN', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Víctor Mas Tah", main_political_party: 'PAN', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Nelia Guadalupe Uc Sosa", main_political_party: 'PRD', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Ludivina Menchaca Castellanos", main_political_party: 'MC', candidacy: Candidacy::PRESIDENTE_MUNICIPAL }
]

morena_pes_pt_candidates = [
  { name: "Marybel Villegan Canché", main_political_party: 'Morena', candidacy: Candidacy::SENADOR },
  { name: "José Luis Pech Várguez", main_political_party: 'Morena', candidacy: Candidacy::SENADOR },
  { name: "Adriana Teissier Zabala", main_political_party: 'Morena', candidacy: Candidacy::DIPUTADO_FEDERAL_D1 },
  { name: "Patricia Palma Olvera", main_political_party: 'Morena', candidacy: Candidacy::DIPUTADO_FEDERAL_D2 },
  { name: "Gregorio Sanchez Martinez", main_political_party: 'PES', candidacy: Candidacy::DIPUTADO_FEDERAL_D3 },
  { name: "Jesús Pool Moo", main_political_party: 'Morena', candidacy: Candidacy::DIPUTADO_FEDERAL_D4 },
  { name: "Hernán Pastrana Pastrana", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Maricarmen Hernández Solís", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "José Domingo Flota Castillo", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Juanita Alonso Marrufo", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "María Elena H. Lezama Espinoza", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Edgar Gasca Arceo", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Laura Beristain Navarrete", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Eloísa Balam Mazum", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Rivelino Valdivia Villaseca", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Juan Pablo Aguilera Negrón", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
]

pri_pvem = [
  { name: "Juan Carrillo Soberanis", main_political_party: 'PRI', candidacy: Candidacy::PRESIDENTE_MUNICIPAL }
]

pri_only = [
  { name: "Rossana Romero Ávila", main_political_party: 'PRI', candidacy: Candidacy::PRESIDENTE_MUNICIPAL }
]

morena_only = [
  { name: "Alma Margarita Lomas Álvarez", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL }
]

pes_only = [
  { name: "Alma Margarita Lomas Álvarez", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Juan Carlos Osorio Magaña", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Marta Canul Tut", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "María Ruiz Molina", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Jesús Valencia Cardín", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "María Trinidad Guillén Núñes", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Niurkia Sáliva Benítez", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Salvador Rocha Vargas", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Francisco Poot Cauil", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Eloísa Zatina Barriga", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Luis Fernando Roldán Carrillo", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL }
]

nueva_alianza_only = [
  { name: "Rosana Martínez Cen", main_political_party: 'PANAL', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: "Erick Borges Yam", main_political_party: 'PANAL', candidacy: Candidacy::PRESIDENTE_MUNICIPAL }
]

pt_only = [
  { name: "Nivardo Mena Valenzuela", main_political_party: 'PT', candidacy: Candidacy::PRESIDENTE_MUNICIPAL }
]

independientes = [
  { name: 'Julio Alfonso Villegas Velázquez', main_political_party: 'Independiente', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: 'Prudencio Alcocer Balan', main_political_party: 'Independiente', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: 'Isaac Janix Alanís', main_political_party: 'Independiente', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: 'Gloria Mex Alcocer', main_political_party: 'Independiente', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: 'Fanny Cahum Fernández', main_political_party: 'Independiente', candidacy: Candidacy::PRESIDENTE_MUNICIPAL },
  { name: 'Wendy Ruiz Aguilar', main_political_party: 'Independiente', candidacy: Candidacy::PRESIDENTE_MUNICIPAL }
]

