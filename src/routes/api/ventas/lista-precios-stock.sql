SELECT  LPRECIO.CODIGO codigo, 
        PROD.rubro_id,
        RUBROS.nombrerubro,
        RUBROS.detalle,
        SEGMENTO.nombre5 marca,
        SEGMENTO.nombre1 color, 
        SEGMENTO.nombre2 tipoproducto, 
        SEGMENTO.nombre3 dibujo, 
        SEGMENTO.nombre4 pulido, 
        LPRECIO.DESCRIPCION descripcion, 
        LPRECIO.INICIAL2_IMPORTE importe, 
        MONEDA.NOMBRE moneda, 
        UNIDADES.NOMBRE unidad,
        coalesce(
              (
                SELECT sum(coalesce(inv.cantidad2_cantidad,0)) 
                FROM iteminventario inv 
                LEFT JOIN DEPOSITO DEP 
                ON DEP.ID = INV.DEPOSITO_ID 
                WHERE prod.id = inv.producto_id 
                AND inv.bo_place_id = '7e03c373-b9af-443d-9c3d-89958f9d51a0' 
                AND DEP.nombre = 'General'
              ),0) GENERAL, 
        coalesce( 
                  (
                    SELECT sum(coalesce(inv.cnolineal2_cantidad,0)) 
                    FROM iteminventario inv 
                    LEFT JOIN DEPOSITO DEP 
                    ON DEP.ID = INV.DEPOSITO_ID 
                    WHERE prod.id = inv.producto_id 
                    AND inv.bo_place_id = '7e03c373-b9af-443d-9c3d-89958f9d51a0' 
                    AND DEP.nombre = 'General'
                  ),0) GeneralNL, 
        coalesce( 
                  (
                    SELECT sum(coalesce(inv.cantidad2_cantidad,0)) 
                    FROM iteminventario inv 
                    LEFT JOIN DEPOSITO DEP 
                    ON DEP.ID = INV.DEPOSITO_ID 
                    WHERE prod.id = inv.producto_id 
                    AND inv.bo_place_id = '5f56cb84-806b-4984-9213-28204c605a97' 
                    AND DEP.nombre = 'Reservado'
                  ),0) RESERVADO, 
        coalesce( 
                  (
                    SELECT sum(coalesce(inv.cnolineal2_cantidad,0)) 
                    FROM iteminventario inv 
                    LEFT JOIN DEPOSITO DEP 
                    ON DEP.ID = INV.DEPOSITO_ID 
                    WHERE prod.id = inv.producto_id 
                    AND inv.bo_place_id = '5f56cb84-806b-4984-9213-28204c605a97' 
                    AND DEP.nombre = 'Reservado'
                  ),0) ReservadoNL, 
        coalesce( 
                  (
                    SELECT sum(coalesce(inv.cantidad2_cantidad,0)) 
                    FROM iteminventario inv 
                    LEFT JOIN DEPOSITO DEP 
                    ON DEP.ID = INV.DEPOSITO_ID 
                    WHERE prod.id = inv.producto_id 
                    AND inv.bo_place_id = '1998C4FA-2CAC-4828-BBA6-D3084EAA4F85' 
                    AND DEP.nombre = 'Bloqueado'
                  ),0) BLOQUEADO, 
        coalesce( 
                  (
                    SELECT sum(coalesce(inv.cnolineal2_cantidad,0)) 
                    FROM iteminventario inv 
                    LEFT JOIN DEPOSITO DEP 
                    ON DEP.ID = INV.DEPOSITO_ID 
                    WHERE prod.id = inv.producto_id 
                    AND inv.bo_place_id = '1998C4FA-2CAC-4828-BBA6-D3084EAA4F85' 
                    AND DEP.nombre = 'Bloqueado'
                  ),0) BloqueadoNL

FROM   V_PRECIO LPRECIO  
LEFT JOIN V_CODIGOALTERNATIVO ALIAS_1 ON LPRECIO.CODIGOALTERNATIVO_ID = ALIAS_1.ID   
LEFT JOIN V_UNIDADFINANCIERA MONEDA ON LPRECIO.VALOR2_UNIDADVALORIZACION_ID = MONEDA.ID   
LEFT JOIN V_UNIDADMEDIDA UNIDADES ON LPRECIO.DCANTIDAD2_UNIDADMEDIDA_ID = UNIDADES.ID  
LEFT JOIN (
            SELECT  id, segmento_id, codigo, rubro_id
            FROM    producto
            UNION
            SELECT  id, segmento_id, codigo, rubro_id
            FROM    Servicio
            UNION
            SELECT  id, segmento_id, codigo, rubro_id
            FROM    ConceptoContable
          ) PROD on LPRECIO.codigo = PROD.codigo
LEFT JOIN RUBRO RUBROS ON PROD.rubro_id = RUBROS.id
LEFT JOIN SEGMENTO ON PROD.SEGMENTO_ID = SEGMENTO.ID 

WHERE LPRECIO.BO_PLACE_ID = '{0724B015-1856-4450-8F59-07BC183F892E}'   