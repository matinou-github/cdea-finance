class IndiceSettingController < ApplicationController
	layout 'dashboard'
	def index
		@indice_setting = IndiceSetting.first_or_initialize 
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
		params.require(:indice_setting).permit(:kg_ha_laboure, :kg_litre_octroi, :valeur_soja, :taux_majoration, :garantie_ha, :garantie_litre, :frais_dossier)
	end
end