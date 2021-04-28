function val = ComputeVonMisesStress(carStress)
	%% order: sigma_x, sigma_y, tadisxy (2D)
	%% order: sigma_x, sigma_y, sigma_z, tadisyz, tadiszx, tadisxy (3D)
	global eleType_;
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		val = sqrt(carStress(:,1).^2 + carStress(:,2).^2 - carStress(:,1).*carStress(:,2) + 3*carStress(:,3).^2 );	
	else
		val = sqrt(0.5*((carStress(:,1)-carStress(:,2)).^2 + (carStress(:,2)-carStress(:,3)).^2 + (carStress(:,3)...
				-carStress(:,1)).^2 ) + 3*( carStress(:,6).^2 + carStress(:,4).^2 + carStress(:,5).^2 ));	
	end	
end
