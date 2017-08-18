SELECT *, (case when (PENDIENTE = 0 and CANT_ORIGINAL <> 0) THEN 'Saldado' else 'No Saldado' end) flag 
FROM (select per.nombre cliente,
ven2.nombre vendedor,
SEGMENTO.nombre1 color,
SEGMENTO.nombre2 tipoproducto,
SEGMENTO.nombre3 dibujo,
SEGMENTO.nombre4 pulido,
SEGMENTO.nombre5 marca, 
SEGMENTO.nombre6 prensa ,
SEGMENTO.nombre7 tipocemento, 
ipend.puedesaldarse puedesaldarse,
 udpro.dimension,
      trov.numerodocumento nrodocumento, 
trov.fechaven2 fechadocumento,
         SUBSTRING(trov.fechaven2,1,4) ||'/'|| SUBSTRING(trov.fechaven2,5,2) ||'/'|| SUBSTRING(trov.fechaven2,7,2) Fechadocumento, 

trov.fechaactual fecha_documento, 
       SUBSTRING(trov.fechaactual,1,4) ||'/'|| SUBSTRING(trov.fechaactual,5,2) ||'/'|| SUBSTRING(trov.fechaactual,7,2) Fecha_documento, 

trov.fechaentrega fecha_entrerga,
       SUBSTRING(trov.fechaentrega,1,4) ||'/'|| SUBSTRING(trov.fechaentrega,5,2) ||'/'|| SUBSTRING(trov.fechaentrega,7,2) Fecha_entrega, 

      COALESCE(TROV.nombre,'SIN DOC') NRO_DOC, 
      --COALESCE(TROV.numerodocumento,'SIN DOC') NRO_DOC, 
      PROD.CODIGO COD_PRODUCTO, PROD.DESCRIPCION DESC_PROD, 
      SUM(COALESCE(IOV.CANTIDAD2_CANTIDAD,0)) CANT_ORIGINAL, 
      (SUM(COALESCE(IOV.CANTIDAD2_CANTIDAD,0) - COALESCE(IPEND.CANTPEND2_CANTIDAD,0))) ENTREGADO,
      sum(coalesce(ipend.cantpend2_cantidad,0)) PENDIENTE, 

      coalesce((select sum(coalesce(inv.cantidad2_cantidad,0))
                  from iteminventario inv 
                  LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID
                 where prod.id = inv.producto_id and inv.bo_place_id = '7e03c373-b9af-443d-9c3d-89958f9d51a0' and DEP.nombre = 'General'
              ),0) GENERAL,

     coalesce((select sum(coalesce(inv.cnolineal2_cantidad,0))
                  from iteminventario inv 
                  LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID
                 where prod.id = inv.producto_id and inv.bo_place_id = '7e03c373-b9af-443d-9c3d-89958f9d51a0' and DEP.nombre = 'General'
              ),0) GeneralNL,

     coalesce((select sum(coalesce(inv.cantidad2_cantidad,0))
                  from iteminventario inv 
                  LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID
                 where prod.id = inv.producto_id and inv.bo_place_id = '5f56cb84-806b-4984-9213-28204c605a97' and DEP.nombre = 'Reservado'
              ),0) RESERVADO,

     coalesce((select sum(coalesce(inv.cnolineal2_cantidad,0))
                  from iteminventario inv 
                  LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID
                 where prod.id = inv.producto_id and inv.bo_place_id = '5f56cb84-806b-4984-9213-28204c605a97' and DEP.nombre = 'Reservado'
              ),0) ReservadoNL,

     coalesce((select sum(coalesce(inv.cantidad2_cantidad,0))
      from iteminventario inv
      LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID
           where prod.id = inv.producto_id and inv.bo_place_id = '1998C4FA-2CAC-4828-BBA6-D3084EAA4F85' and DEP.nombre = 'Bloqueado'
         ),0) BLOQUEADO,

     coalesce((select sum(coalesce(inv.cnolineal2_cantidad,0))
      from iteminventario inv
      LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID
           where prod.id = inv.producto_id and inv.bo_place_id = '1998C4FA-2CAC-4828-BBA6-D3084EAA4F85' and DEP.nombre = 'Bloqueado'
         ),0) BloqueadoNL,

  coalesce((select sum(coalesce(inv.cnolineal2_cantidad,0))
                  from iteminventario inv 
                  LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID
                 where prod.id = inv.producto_id and inv.bo_place_id = '5f56cb84-806b-4984-9213-28204c605a97' and DEP.nombre = 'Reservado'
              ),0) + coalesce((select sum(coalesce(inv.cnolineal2_cantidad,0))
      from iteminventario inv
      LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID
           where prod.id = inv.producto_id and inv.bo_place_id = '1998C4FA-2CAC-4828-BBA6-D3084EAA4F85' and DEP.nombre = 'Bloqueado'
         ),0) SUBTOTAL,

   coalesce((select sum(coalesce(inv.cnolineal2_cantidad,0))
                  from iteminventario inv 
                  LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID
                 where prod.id = inv.producto_id and inv.bo_place_id = '5f56cb84-806b-4984-9213-28204c605a97' and DEP.nombre = 'Reservado'
              ),0)+coalesce((select sum(coalesce(inv.cnolineal2_cantidad,0))
      from iteminventario inv
      LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID
           where prod.id = inv.producto_id and inv.bo_place_id = '1998C4FA-2CAC-4828-BBA6-D3084EAA4F85' and DEP.nombre = 'Bloqueado'
         ),0)+coalesce((select sum(coalesce(inv.cnolineal2_cantidad,0))
                  from iteminventario inv 
                  LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID
                 where prod.id = inv.producto_id and inv.bo_place_id = '7e03c373-b9af-443d-9c3d-89958f9d51a0' and DEP.nombre = 'General'
              ),0) TOTAL,

     (SELECT COALESCE( ( SELECT SUM(ITEMTR.CANTPEND2_CANTIDAD)
        FROM itemtr 
       where tipotransacciondestino_id = '5082974a-5905-11d5-86c4-0080ad403f5f'
         and cancelado = false AND ITEMTR.REFERENCIA_ID = PROD.ID),0)) PROYECTADO_COMPRAS

       from producto prod
      inner join ITEMORDENVENTA IOV ON IOV.REFERENCIA_ID = PROD.ID
       LEFT OUTER JOIN ITEMTR IPEND ON IPEND.ITEMTRANSACCION_ID = IOV.ID 
        and IPEND.TIPOTRANSACCIONDESTINO_id = '89c23593-3f01-11d5-86ad-0080ad403f5f'
       LEFT OUTER JOIN TRORDENVENTA TROV ON TROV.ITEMSTRANSACCION_ID = IOV.BO_PLACE_ID
       left outer join v_cliente cli on trov.destinatario_id = cli.id
       left outer join v_persona per on cli.enteasociado_id = per.id
       left outer join v_vendedor ven on trov.originante_id = ven.id
       left outer join v_persona ven2 on ven.enteasociado_id = ven2.id
       LEFT OUTER JOIN TIPOTRANSACCION TIPOTR ON TIPOTR.ID = TROV.TIPOTRANSACCION_ID
      LEFT OUTER JOIN SEGMENTO ON PROD.SEGMENTO_ID = SEGMENTO.ID
       LEFT OUTER JOIN ITEMTIPOCLASIFICADOR ITC ON ITC.ID = SEGMENTO.SEGMENTO5_ID
       left outer join ud_producto udpro on prod.boextension_id = udpro.id
      WHERE PROD.CODIGO <> '' 
      GROUP BY per.nombre, ven2.nombre, SEGMENTO.nombre1, SEGMENTO.nombre2,SEGMENTO.nombre3,SEGMENTO.nombre4,SEGMENTO.nombre5,SEGMENTO.nombre6,SEGMENTO.nombre7,IPEND.puedesaldarse,udpro.dimension,
               PROD.ID, trov.numerodocumento, trov.fechaven2, trov.fechaactual , trov.fechaentrega , COALESCE(TROV.nombre,'SIN DOC'), PROD.CODIGO, ITC.NOMBRE, PROD.DESCRIPCION, PROD.STOCKMINIMO, PROD.STOCKMAXIMO,
               PROD.PUNTOPEDIDO
     ) Q 
WHERE pendiente <> 0  and (CANT_ORIGINAL <> 0 OR ENTREGADO <> 0 OR PENDIENTE <> 0 OR GENERAL <> 0 or GeneralNL <> 0 OR RESERVADO <> 0 or ReservadoNL <> 0 OR BLOQUEADO <> 0 or BloqueadoNL <> 0 OR SUBTOTAL <> 0 OR TOTAL <> 0)
--order by  fecha_documento asc, nro_doc, cod_producto 