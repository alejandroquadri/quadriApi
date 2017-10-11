SELECT 
	ALIAS_9.DESCRIPCION Ejercicio,
	replace(replace(replace(replace(replace(substring(alias_8.codigo,1,2),'1.','Activo'),'2.','Pasivo'),'3.','Patrimonio Neto'),'4.','Ingresos'),'5.','Egresos') as Estructura,
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(substring(alias_8.codigo,1,4),'1.1.','Activo Corriente'),'1.2.','Activo No Corriente'),'2.1.','Pasivo Corriente'),'3.1.','Capital Social'),'4.1.','Ventas'),'4.2.','Otros Ingresos'),'5.1.','CMV'),'5.2.','Gast. de Planta'),'5.3.','Gast. Comercializacion'),'5.4.','Gasto Adm'),'5.5.','Otros Egresos'),'3.2.','Capital Social2'),'3.3.','Resultado del Ejercicio') as tipo,
	ALIAS_7.CODIGO CODIGO, 
	ALIAS_0.DESCRIPCION DESCRIPCION, 
	sum(ALIAS_0.DEBE2_IMPORTE - ALIAS_0.HABER2_IMPORTE) SALDO
	FROM  V_ITEMCONTABLE ALIAS_0  
	LEFT OUTER JOIN V_UOCONTABILIDAD ALIAS_1 ON ALIAS_0.UNIDADOPERATIVA_ID = ALIAS_1.ID   
	LEFT OUTER JOIN V_ESQUEMAOPERATIVO ALIAS_10 ON ALIAS_1.ESQUEMAOPERATIVO_ID = ALIAS_10.ID   
	LEFT OUTER JOIN V_TIPOTRANSACCION ALIAS_2 ON ALIAS_0.TIPOTRANSACCION_ID = ALIAS_2.ID   
	LEFT OUTER JOIN V_TRCONTABLE ALIAS_3 ON ALIAS_0.PLACEOWNER_ID = ALIAS_3.ID   
	LEFT OUTER JOIN V_FLAG ALIAS_6 ON ALIAS_3.FLAG_ID = ALIAS_6.ID   
	LEFT OUTER JOIN V_IMPUTACIONCONTABLE ALIAS_4 ON ALIAS_0.IMPUTACIONCONTABLE_ID = ALIAS_4.ID   
	LEFT OUTER JOIN V_CENTROCOSTOS ALIAS_5 ON ALIAS_0.CENTROCOSTOS_ID = ALIAS_5.ID   
	LEFT OUTER JOIN V_CUENTA ALIAS_7 ON ALIAS_0.REFERENCIA_ID = ALIAS_7.ID   
	right OUTER JOIN V_TITULOCONTABLE ALIAS_8 ON ALIAS_7.ACUMULA_ID = ALIAS_8.ID   
	LEFT OUTER JOIN V_EJERCICIO ALIAS_9 ON ALIAS_0.EJERCICIO_ID = ALIAS_9.ID   
	LEFT OUTER JOIN V_PERIODO ALIAS_11 ON ALIAS_0.PERIODO_ID = ALIAS_11.ID
	LEFT OUTER JOIN V_SUBDIARIO SUBDIARIO ON SUBDIARIO.ID = ALIAS_0.SUBDIARIO_ID  
	LEFT OUTER JOIN UD_CUENTACONTABLE CC ON CC.ID = ALIAS_7.BOEXTENSION_ID
	LEFT OUTER JOIN V_ITEMTIPOCLASIFICADOR IC ON CC.TIPOGANANCIA_ID = IC.ID
	LEFT OUTER JOIN V_ITEMTIPOCLASIFICADOR IC1 ON CC.TIPOMOVIMIENTO_ID = IC1.ID
	LEFT OUTER JOIN V_ITEMTIPOCLASIFICADOR IC2 ON CC.TIPOGASTO_ID = IC2.ID
	WHERE    
	ALIAS_0.BO_PLACE_ID IS NOT NULL   AND  
	substring(alias_0.fechavencimiento,1,8) >= substring('20150701',1,8) and
	substring(alias_0.fechavencimiento,1,8) <= ${fechaHasta} 

 and alias_7.codigo not like '5%' 
 and alias_7.codigo not like '6%' 
	and (ALIAS_0.ESTADOTR = 'A' OR ALIAS_0.ESTADOTR = 'C') 
 Group by alias_7.codigo, alias_0.descripcion, alias_9.descripcion, alias_8.codigo 
 order by codigo 