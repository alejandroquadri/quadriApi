
  	Select tr.numerodocumento as numero, 
--        tr.nombreoriginante as vendedor,
   ven.codigo as vendedor, 
 	
         'Remito' as transaccion, 
  	replace(replace(substring(tr.nombre,1,9),'Rto.Vta. ','Rto Venta'),'Rto.Vta.M','Rto Mostrador') as TipoTransaccion, 
         Case when itc.nombre = 'Quadri' then 'Productos Elaborados' 
  when itc.nombre = 'Flete' then 'Flete' 
              else 'Reventa' 
         End  as TipoProducto,  
--         tr.fechaactual as Fecha, 

         SUBSTRING(tr.fechaactual,1,4) ||'/'|| SUBSTRING(tr.fechaactual,5,2) ||'/'|| SUBSTRING(tr.fechaactual,7,2) Fecha,  
 
  SUBSTRING(tr.fechaactual,5,2) MES, 
  SUBSTRING(tr.fechaactual,1,4) AÑO, 
         itr.descripcion as Descripcion, 
--''         Case when nota = 'A' then 'Responsable Inscripto' 
--''  	            else 'Consumidor Final'  
--''         End  as TipoConsumidor,  
        	itr.totalsindescuentos as Neto, 
    itr.totalsindescuentos - itr.impboni2_importe - itr.impdesc2_importe as total, 
  seg.nombre1 as Color, 
  seg.nombre2 as tipoproduto, 
  seg.nombre3 as Dibujo, 
  seg.nombre4 as pulido, 
  seg.nombre5 as marca, 
  seg.nombre6 as prensa, 
  seg.nombre7 as tipocemento, 
  itr.nombrereferencia as codigo, 
  rub.nombrerubro as rubro, 
  alias_2.descripcion as origen, 
  itr.cantidad2_cantidad as cantidad, 
  un.simbolo as unidadmedida, 
   tr.nombredestinatario as cliente 

 
 
    from tregresoinventario tr 
    left join itemegresoinventario itr on itr.bo_place_id = tr.itemstransaccion_id  
    left outer join (select id, segmento_id, rubro_id from producto 
                     Union 
                     Select id, segmento_id, rubro_id from Servicio 
                     Union 
                     Select id, segmento_id, rubro_id from ConceptoContable) prod on prod.id = itr.referenciatipo_id 
    left outer join segmento seg on seg.id = prod.segmento_id  
    left outer join itemtipoclasificador itc on itc.id = seg.segmento5_id 
   left outer join rubro rub on rub.id = prod.rubro_id 
       LEFT OUTER JOIN UD_remitoventa ALIAS_1 ON tr.BOEXTENSION_ID = ALIAS_1.ID  
     left join grupovistas alias_2 on alias_2.id = alias_1.origenrto_id  
   left join unidadmedida un on un.id = itr.unidadmedida_id  
 left join vendedor ven on tr.vendedor_id = ven.id 


   -- where substring(tr.fechaactual,1 ,8) >= '" & xFechaDesde & "'   
   --   and substring(tr.fechaactual,1 ,8) <= '" & xFechaHasta & "'   

   where SUBSTRING(tr.fechaactual, 1, 8) >= SUBSTRING(${fechaDesde}, 1, 8) 
    AND SUBSTRING(tr.fechaactual, 1, 8) <= SUBSTRING(${fechaHasta}, 1, 8) 
    and tr.nombre not like 'SdoInCli%' 
and tr.nombre not like 'Egr.Merc%'
 
 
  union all
	Select tr.numerodocumento as numero, 
--''         tr.nombreoriginante as vendedor,
 ven.codigo as endedor, 
 	
         'Remito Anulado' as transaccion, 
  	replace(replace(substring(tr.nombre,1,9),'Rto.Vta. ','Rto Venta'),'Rto.Vta.M','Rto Mostrador') as TipoTransaccion, 
         Case when itc.nombre = 'Quadri' then 'Productos Elaborados' 
  when itc.nombre = 'Flete' then 'Flete' 
              else 'Reventa' 
         End  as TipoProducto,  
--''         tr.fechaactual as Fecha, 
 
         SUBSTRING(tr.fechaactual,1,4) ||'/'|| SUBSTRING(tr.fechaactual,5,2) ||'/'|| SUBSTRING(tr.fechaactual,7,2) Fecha,  
 
  SUBSTRING(tr.fechaactual,5,2) MES, 
  SUBSTRING(tr.fechaactual,1,4) AÑO, 
         itr.descripcion as Descripcion, 
--''         Case when nota = 'A' then 'Responsable Inscripto' 
--''  	            else 'Consumidor Final'  
--''         End  as TipoConsumidor,

  
        	itr.totalsindescuentos as Neto, 
    itr.totalsindescuentos - itr.impboni2_importe - itr.impdesc2_importe as total, 
  seg.nombre1 as Color, 
  seg.nombre2 as tipoproduto, 
  seg.nombre3 as Dibujo, 
  seg.nombre4 as pulido, 
  seg.nombre5 as marca, 
  seg.nombre6 as prensa, 
  seg.nombre7 as tipocemento, 
  itr.nombrereferencia as codigo, 
  rub.nombrerubro as rubro, 
  alias_2.descripcion as origen, 
  itr.cantidad2_cantidad as cantidad, 
  un.simbolo as unidadmedida, 
   tr.nombredestinatario as cliente 
 
 
 
    from tringresoinventario tr 
    left join itemingresoinventario itr on itr.bo_place_id = tr.itemstransaccion_id  
    left outer join (select id, segmento_id, rubro_id from producto 
                     Union 
                     Select id, segmento_id, rubro_id from Servicio 
                     Union 
                     Select id, segmento_id, rubro_id from ConceptoContable) prod on prod.id = itr.referenciatipo_id 
    left outer join segmento seg on seg.id = prod.segmento_id  
    left outer join itemtipoclasificador itc on itc.id = seg.segmento5_id 
   left outer join rubro rub on rub.id = prod.rubro_id 
       LEFT OUTER JOIN UD_remitoventa ALIAS_1 ON tr.BOEXTENSION_ID = ALIAS_1.ID  
     left join grupovistas alias_2 on alias_2.id = alias_1.origenrto_id  
   left join unidadmedida un on un.id = itr.unidadmedida_id  
 left join tregresoinventario tre on tre.id = tr.vinculotr_id  
 left join vendedor ven on tre.vendedor_id = ven.id 

   --where substring(tr.fechaactual,1 ,8) >= '" & xFechaDesde & "'   
    -- and substring(tr.fechaactual,1 ,8) <= '" & xFechaHasta & "' 

   where SUBSTRING(tr.fechaactual, 1, 8) >= SUBSTRING('20160701', 1, 8) 
    AND SUBSTRING(tr.fechaactual, 1, 8) <= SUBSTRING('20170728', 1, 8) 
    and tr.nombre not like 'SdoInCli%' 
and tr.nombre not like 'Ingr.Merc%'
and tr.nombre not like 'Rec.Merc.%'