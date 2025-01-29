class IndiceSettingController < ApplicationController
	layout 'dashboard'
	def index
		@indice_setting = IndiceSetting.first_or_initialize 
		@village_setting = VillageSetting.new
		@villages = VillageSetting.all
	end


	def update
		@indice_setting = IndiceSetting.first_or_initialize 

		if @indice_setting.update(indice_setting_params)
			redirect_to indice_setting_path
			flash[:success] = "Configuration sauvégarder avec succes"
		else
			redirect_to indice_setting_path
			flash[:error] = "Echec de la sauvégarde"
		end
	end

	private

	def indice_setting_params
		params.require(:indice_setting).permit(:valeur_superficie, :gerant_name, :kg_mais_par_soja, :valeur_soja, :taux_majoration, :garantie_ha, :frais_dossier) 
	end
end