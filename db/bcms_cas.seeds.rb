group = Group.create!(:name=>"CAS Authenticated Users", 
                      :code=>"cas_group", 
                      :group_type=>GroupType.find_by_name("Registered Public User"))
group.sections = Section.all