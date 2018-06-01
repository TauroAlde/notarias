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
  { district_number: 3 },
  { district_number: 4 }
])

def load_segments(segments_array, parent_segment = nil)
  segments_array.each do |segment_hash|
    puts "creating #{segment_hash["name"]} segment"
    child_segment = Segment.create(name: segment_hash["name"],
                                   district: District.find_by(district_number: segment_hash["district"]),
                                   nominal_count: segment_hash["nominal_count"])
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
  { name: Candidacy::SENADOR_PRIMERA_FORMULA },
  { name: Candidacy::SENADOR_SEGUNDA_FORMULA }
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
  
  political_party = PoliticalParty.find_or_initialize_by(name: coalition[:name], coalition: true)
  political_party.save! if political_party.new_record?
  political_party.coalition_relationships.create(coalition[:names].map do |parent_political_party|
    { parent_political_party: PoliticalParty.find_by(name: parent_political_party) }
  end)
end

def add_political_candidacy(candidates_array, political_party_name)
  candidates_array.each do |candidate|
    PoliticalCandidacy.create(
      candidacy: Candidacy.find_by(name: candidate[:candidacy]),
      segment: candidate[:segment],
      district: candidate[:district],
      candidate_attributes: {
        name: candidate[:name],
        main_political_party: PoliticalParty.find_by(name: candidate[:main_political_party]),
        political_party: PoliticalParty.find_by(name: political_party_name)
      }
    )
  end
end

pri_pvem_panal_candidates = [
  { name: "José Antonio Meade", main_political_party: 'PRI', candidacy: Candidacy::PRESIDENCIA, segment: Segment.root },
  { name: "Susana Hurtado Vallejo", main_political_party: 'PANAL', candidacy: Candidacy::SENADOR_PRIMERA_FORMULA, segment: Segment.root },
  { name: "Raymundo King de la Rosa", main_political_party: 'PRI', candidacy: Candidacy::SENADOR_SEGUNDA_FORMULA, segment: Segment.root },
  { name: "Leslie Hendricks Rubio", main_political_party: 'PRI', candidacy: Candidacy::DIPUTADO_FEDERAL_D1, segment: Segment.root, district: District.find_by(district_number: 1) },
  { name: "Cora Amalia Castilla Madrid", main_political_party: 'PRI', candidacy: Candidacy::DIPUTADO_FEDERAL_D2, segment: Segment.root, district: District.find_by(district_number: 2) },
  { name: "Ana Patricia Peralta De la Peña", main_political_party: 'PVEM', candidacy: Candidacy::DIPUTADO_FEDERAL_D3, segment: Segment.root, district: District.find_by(district_number: 3) },
  { name: "Elda Candelaria Ayuso Achach", main_political_party: 'PRI', candidacy: Candidacy::DIPUTADO_FEDERAL_D4, segment: Segment.root, district: District.find_by(district_number: 4) }, # these are giiving null
  { name: "María Hadad Castillo", main_political_party: 'PRI', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.othon_p_blanco },
  { name: "Paoly Elizabeth Perera Maldonado", main_political_party: 'PRI', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.felipe_carrillo_puerto},
  { name: "Pedro Oscar Joaquin Delbouis", main_political_party: 'PRI', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.cozumel },
  { name: "Fabiola Ileana Cervera Vidal", main_political_party: 'PANAL', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.lazaro_cardenas },
  { name: "Mario Machuca Sánchez", main_political_party: 'PVEM', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.benito_juarez },
  { name: "Martin De la Cruz Gómez", main_political_party: 'PRI', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.solidaridad },
  { name: "Marciano Dzul Caamal", main_political_party: 'PRI', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.tulum },
  { name: "Manuel Alexander Zetina Aguiluz", main_political_party: 'PANAL', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.bacalar },
  { name: "Laura Lynn Fernandez Piña", main_political_party: 'PVEM', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.puerto_morelos },
]

add_political_candidacy(pri_pvem_panal_candidates, 'PRI/PVEM/PANAL')

pan_prd_mc_candidates = [
  { name: "Ricardo Anaya Cortés", main_political_party: 'PAN', candidacy: Candidacy::PRESIDENCIA, segment: Segment.root },
  { name: "Julián Ricalde", main_political_party: 'PRD', candidacy: Candidacy::SENADOR_PRIMERA_FORMULA, segment: Segment.root },
  { name: "Mayuli Latifa Martínez Simón", main_political_party: 'PAN', candidacy: Candidacy::SENADOR_SEGUNDA_FORMULA, segment: Segment.root },
  { name: "Miguel Ramón Martín Azueta", main_political_party: 'MC', candidacy: Candidacy::DIPUTADO_FEDERAL_D1, segment: Segment.root, district: District.find_by(district_number: 1) },
  { name: "Luis Torres Llanes", main_political_party: 'PAN', candidacy: Candidacy::DIPUTADO_FEDERAL_D2, segment: Segment.root, district: District.find_by(district_number: 2) },
  { name: "Karla Romero Gómez", main_political_party: 'PRD', candidacy: Candidacy::DIPUTADO_FEDERAL_D3, segment: Segment.root, district: District.find_by(district_number: 3) },
  { name: "Gabriela López Pallares", main_political_party: 'PRD', candidacy: Candidacy::DIPUTADO_FEDERAL_D4, segment: Segment.root, district: District.find_by(district_number: 4) },
  { name: "Fernando Zelaya Espinoza", main_political_party: 'PAN', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.othon_p_blanco },
  { name: "José Esquivel Vargas", main_political_party: 'PRD', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.felipe_carrillo_puerto },
  { name: "Sofía Alcocer Alcocer", main_political_party: 'PRD', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.jose_maria_morelos },
  { name: "Perla Tun Pech", main_political_party: 'PAN', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.cozumel },
  { name: "María Trinidad García Argüelles", main_political_party: 'PAN', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.lazaro_cardenas },
  { name: "Faustino Uicab Alcocer", main_political_party: 'PAN', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.isla_mujeres },
  { name: "Cristina Torres Gómez", main_political_party: 'PAN', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.solidaridad },
  { name: "Víctor Mas Tah", main_political_party: 'PAN', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.tulum },
  { name: "Nelia Guadalupe Uc Sosa", main_political_party: 'PRD', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.bacalar },
  { name: "Ludivina Menchaca Castellanos", main_political_party: 'MC', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.puerto_morelos }
]

add_political_candidacy(pan_prd_mc_candidates, 'PRD/PAN/MC')

morena_pes_pt_candidates = [
  { name: "Andrés Manuel López Obrador", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENCIA, segment: Segment.root },
  { name: "Marybel Villegan Canché", main_political_party: 'Morena', candidacy: Candidacy::SENADOR_PRIMERA_FORMULA, segment: Segment.root },
  { name: "José Luis Pech Várguez", main_political_party: 'Morena', candidacy: Candidacy::SENADOR_SEGUNDA_FORMULA, segment: Segment.root },
  { name: "Adriana Teissier Zabala", main_political_party: 'Morena', candidacy: Candidacy::DIPUTADO_FEDERAL_D1, segment: Segment.root, district: District.find_by(district_number: 1) },
  { name: "Patricia Palma Olvera", main_political_party: 'Morena', candidacy: Candidacy::DIPUTADO_FEDERAL_D2, segment: Segment.root, district: District.find_by(district_number: 2) },
  { name: "Gregorio Sanchez Martinez", main_political_party: 'PES', candidacy: Candidacy::DIPUTADO_FEDERAL_D3, segment: Segment.root , district: District.find_by(district_number: 3)},
  { name: "Jesús Pool Moo", main_political_party: 'Morena', candidacy: Candidacy::DIPUTADO_FEDERAL_D4, segment: Segment.root, district: District.find_by(district_number: 4) },
  { name: "Hernán Pastrana Pastrana", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.othon_p_blanco },
  { name: "Maricarmen Hernández Solís", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.felipe_carrillo_puerto },
  { name: "José Domingo Flota Castillo", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.jose_maria_morelos },
  { name: "Juanita Alonso Marrufo", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.cozumel },
  { name: "María Elena H. Lezama Espinoza", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.benito_juarez },
  { name: "Edgar Gasca Arceo", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.isla_mujeres },
  { name: "Laura Beristain Navarrete", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.solidaridad },
  { name: "Eloísa Balam Mazum", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.tulum },
  { name: "Rivelino Valdivia Villaseca", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.bacalar },
  { name: "Juan Pablo Aguilera Negrón", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.puerto_morelos },
]

add_political_candidacy(morena_pes_pt_candidates, 'Morena/PES/PT')

pri_pvem = [
  { name: "Juan Carrillo Soberanis", main_political_party: 'PRI', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.jose_maria_morelos }
]

add_political_candidacy(pri_pvem, 'PVEM/PRI')

pri_only = [
  { name: "Rossana Romero Ávila", main_political_party: 'PRI', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.isla_mujeres }
]

add_political_candidacy(pri_only, 'PRI')

morena_only = [
  { name: "Alma Margarita Lomas Álvarez", main_political_party: 'Morena', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.lazaro_cardenas }
]

add_political_candidacy(morena_only, 'Morena')

pes_only = [
  { name: "Juan Carlos Osorio Magaña", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.isla_mujeres },
  { name: "Marta Canul Tut", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.jose_maria_morelos },
  { name: "María Ruiz Molina", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.lazaro_cardenas },
  { name: "Jesús Valencia Cardín", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.othon_p_blanco },
  { name: "María Trinidad Guillén Núñes", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.bacalar },
  { name: "Niurkia Sáliva Benítez", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.benito_juarez },
  { name: "Salvador Rocha Vargas", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.cozumel },
  { name: "Francisco Poot Cauil", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.felipe_carrillo_puerto },
  { name: "Eloísa Zatina Barriga", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.puerto_morelos },
  { name: "Luis Fernando Roldán Carrillo", main_political_party: 'PES', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.solidaridad }
]

add_political_candidacy(pes_only, 'PES')

nueva_alianza_only = [
  { name: "Rosana Martínez Cen", main_political_party: 'PANAL', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.isla_mujeres },
  { name: "Erick Borges Yam", main_political_party: 'PANAL', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.jose_maria_morelos }
]

add_political_candidacy(nueva_alianza_only, 'PANAL')

pt_only = [
  { name: "Nivardo Mena Valenzuela", main_political_party: 'PT', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.lazaro_cardenas }
]

add_political_candidacy(pt_only, 'PT')

independientes = [
  { name: "Jaime Rodríguez Calderón", main_political_party: 'Independiente', candidacy: Candidacy::PRESIDENCIA, segment: Segment.root },
  { name: 'Julio Alfonso Villegas Velázquez', main_political_party: 'Independiente', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.othon_p_blanco },
  { name: 'Prudencio Alcocer Balan', main_political_party: 'Independiente', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.bacalar },
  { name: 'Isaac Janix Alanís', main_political_party: 'Independiente', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.benito_juarez },
  { name: 'Gloria Mex Alcocer', main_political_party: 'Independiente', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.cozumel },
  { name: 'Fanny Cahum Fernández', main_political_party: 'Independiente', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.felipe_carrillo_puerto },
  { name: 'Wendy Ruiz Aguilar', main_political_party: 'Independiente', candidacy: Candidacy::PRESIDENTE_MUNICIPAL, segment: Segment.tulum }
]

add_political_candidacy(independientes, 'Independiente')


