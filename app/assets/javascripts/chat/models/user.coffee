class @User
  constructor: (data)->
    @data = data
    @id = data.id
    @name = data.name
    @mother_last_name = data.mother_last_name
    @father_last_name = data.father_last_name
    @full_name = data.full_name
