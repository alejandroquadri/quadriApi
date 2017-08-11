SELECT * 
FROM 
  (SELECT SEGMENTO.nombre1 color, 
          SEGMENTO.nombre2 tipoproducto, 
          SEGMENTO.nombre3 dibujo, 
          SEGMENTO.nombre4 pulido, 
          SEGMENTO.nombre5 marca, 
          SEGMENTO.nombre6 prensa, 
          SEGMENTO.nombre7 tipocemento, 
          udpro.dimension, 
          PROD.CODIGO COD_PRODUCTO, 
          PROD.DESCRIPCION DESC_PROD, 
          coalesce( 
                     (SELECT sum(coalesce(inv.cantidad2_cantidad,0)) 
                      FROM iteminventario inv 
                      LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID 
                      WHERE prod.id = inv.producto_id 
                        AND inv.bo_place_id = '7e03c373-b9af-443d-9c3d-89958f9d51a0' 
                        AND DEP.nombre = 'General' ),0) GENERAL, 
                                                        coalesce( 
                                                                   (SELECT sum(coalesce(inv.cnolineal2_cantidad,0)) 
                                                                    FROM iteminventario inv 
                                                                    LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID 
                                                                    WHERE prod.id = inv.producto_id 
                                                                      AND inv.bo_place_id = '7e03c373-b9af-443d-9c3d-89958f9d51a0' 
                                                                      AND DEP.nombre = 'General' ),0) GeneralNL, 
                                                        coalesce( 
                                                                   (SELECT sum(coalesce(inv.cantidad2_cantidad,0)) 
                                                                    FROM iteminventario inv 
                                                                    LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID 
                                                                    WHERE prod.id = inv.producto_id 
                                                                      AND inv.bo_place_id = '5f56cb84-806b-4984-9213-28204c605a97' 
                                                                      AND DEP.nombre = 'Reservado' ),0) RESERVADO, 
                                                        coalesce( 
                                                                   (SELECT sum(coalesce(inv.cnolineal2_cantidad,0)) 
                                                                    FROM iteminventario inv 
                                                                    LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID 
                                                                    WHERE prod.id = inv.producto_id 
                                                                      AND inv.bo_place_id = '5f56cb84-806b-4984-9213-28204c605a97' 
                                                                      AND DEP.nombre = 'Reservado' ),0) ReservadoNL, 
                                                        coalesce( 
                                                                   (SELECT sum(coalesce(inv.cantidad2_cantidad,0)) 
                                                                    FROM iteminventario inv 
                                                                    LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID 
                                                                    WHERE prod.id = inv.producto_id 
                                                                      AND inv.bo_place_id = '1998C4FA-2CAC-4828-BBA6-D3084EAA4F85' 
                                                                      AND DEP.nombre = 'Bloqueado' ),0) BLOQUEADO, 
                                                        coalesce( 
                                                                   (SELECT sum(coalesce(inv.cnolineal2_cantidad,0)) 
                                                                    FROM iteminventario inv 
                                                                    LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID 
                                                                    WHERE prod.id = inv.producto_id 
                                                                      AND inv.bo_place_id = '1998C4FA-2CAC-4828-BBA6-D3084EAA4F85' 
                                                                      AND DEP.nombre = 'Bloqueado' ),0) BloqueadoNL, 
                                                        coalesce( 
                                                                   (SELECT sum(coalesce(inv.cantidad2_cantidad,0)) 
                                                                    FROM iteminventario inv 
                                                                    LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID 
                                                                    WHERE prod.id = inv.producto_id 
                                                                      AND inv.bo_place_id = '7e03c373-b9af-443d-9c3d-89958f9d51a0' 
                                                                      AND DEP.nombre = 'General' ),0) + coalesce( 
                                                                                                                   (SELECT sum(coalesce(inv.cantidad2_cantidad,0)) 
                                                                                                                    FROM iteminventario inv 
                                                                                                                    LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID 
                                                                                                                    WHERE prod.id = inv.producto_id 
                                                                                                                      AND inv.bo_place_id = '5f56cb84-806b-4984-9213-28204c605a97' 
                                                                                                                      AND DEP.nombre = 'Reservado' ),0) + coalesce( 
                                                                                                                                                                     (SELECT sum(coalesce(inv.cantidad2_cantidad,0)) 
                                                                                                                                                                      FROM iteminventario inv 
                                                                                                                                                                      LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID 
                                                                                                                                                                      WHERE prod.id = inv.producto_id 
                                                                                                                                                                        AND inv.bo_place_id = '1998C4FA-2CAC-4828-BBA6-D3084EAA4F85' 
                                                                                                                                                                        AND DEP.nombre = 'Bloqueado' ),0) SUBTOTAL, 
                                                        coalesce( 
                                                                   (SELECT sum(coalesce(inv.cnolineal2_cantidad,0)) 
                                                                    FROM iteminventario inv 
                                                                    LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID 
                                                                    WHERE prod.id = inv.producto_id 
                                                                      AND inv.bo_place_id = '5f56cb84-806b-4984-9213-28204c605a97' 
                                                                      AND DEP.nombre = 'Reservado' ),0)+coalesce( 
                                                                                                                   (SELECT sum(coalesce(inv.cnolineal2_cantidad,0)) 
                                                                                                                    FROM iteminventario inv 
                                                                                                                    LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID 
                                                                                                                    WHERE prod.id = inv.producto_id 
                                                                                                                      AND inv.bo_place_id = '1998C4FA-2CAC-4828-BBA6-D3084EAA4F85' 
                                                                                                                      AND DEP.nombre = 'Bloqueado' ),0)+coalesce( 
                                                                                                                                                                   (SELECT sum(coalesce(inv.cnolineal2_cantidad,0)) 
                                                                                                                                                                    FROM iteminventario inv 
                                                                                                                                                                    LEFT OUTER JOIN DEPOSITO DEP ON DEP.ID = INV.DEPOSITO_ID 
                                                                                                                                                                    WHERE prod.id = inv.producto_id 
                                                                                                                                                                      AND inv.bo_place_id = '7e03c373-b9af-443d-9c3d-89958f9d51a0' 
                                                                                                                                                                      AND DEP.nombre = 'General' ),0) TOTAL, 

 (case 
  when prod.activestatus = 0 then 'Activo' 
  when prod.activestatus = 1 then 'Suspendido' 
  when prod.activestatus = 2 then 'Dado de baja' 
  else 'Nada' 
  end) Estado 

   FROM producto prod 
   INNER JOIN ITEMORDENVENTA IOV ON IOV.REFERENCIA_ID = PROD.ID 
   LEFT OUTER JOIN ITEMTR IPEND ON IPEND.ITEMTRANSACCION_ID = IOV.ID 
   AND IPEND.TIPOTRANSACCIONDESTINO_id = '89c23593-3f01-11d5-86ad-0080ad403f5f' 
   LEFT OUTER JOIN TRORDENVENTA TROV ON TROV.ITEMSTRANSACCION_ID = IOV.BO_PLACE_ID 
   LEFT OUTER JOIN v_cliente cli ON trov.destinatario_id = cli.id 
   LEFT OUTER JOIN v_persona per ON cli.enteasociado_id = per.id 
   LEFT OUTER JOIN v_vendedor ven ON trov.originante_id = ven.id 
   LEFT OUTER JOIN v_persona ven2 ON ven.enteasociado_id = ven2.id 
   LEFT OUTER JOIN TIPOTRANSACCION TIPOTR ON TIPOTR.ID = TROV.TIPOTRANSACCION_ID 
   LEFT OUTER JOIN SEGMENTO ON PROD.SEGMENTO_ID = SEGMENTO.ID 
   LEFT OUTER JOIN ITEMTIPOCLASIFICADOR ITC ON ITC.ID = SEGMENTO.SEGMENTO5_ID 
   LEFT OUTER JOIN ud_producto udpro ON prod.boextension_id = udpro.id  
--WHERE PROD.CODIGO < '' 
 
   GROUP BY SEGMENTO.nombre1, 
            SEGMENTO.nombre2, 
            SEGMENTO.nombre3, 
            SEGMENTO.nombre4, 
            SEGMENTO.nombre5, 
            SEGMENTO.nombre6, 
            SEGMENTO.nombre7, 
            udpro.dimension, 
            PROD.ID, 
            PROD.CODIGO, 
            PROD.DESCRIPCION ) Q 
WHERE (GENERAL <> 0 
       OR GeneralNL <> 0 
       OR RESERVADO <> 0 
       OR ReservadoNL <> 0 
       OR BLOQUEADO <> 0 
       OR BloqueadoNL <> 0 
       OR SUBTOTAL <> 0 
       OR TOTAL <> 0) 

 and Estado like 'Activo' 

ORDER BY cod_producto