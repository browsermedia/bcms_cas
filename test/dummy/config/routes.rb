Rails.application.routes.draw do

  mount BcmsCas::Engine => "/bcms_cas"
	mount_browsercms
end
