SELECT ALIAS_0.NOMBRETR TRANSACCION,
           ALIAS_0.ESTADOTR ESTADO,
           ALIAS_7.DESCRIPCION FLAG,
           SUBSTRING(ALIAS_0.FECHADOCUMENTO,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,5,2) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,7,2) FECHA_DOCUMENTO,
           SUBSTRING(ALIAS_0.FECHAENTREGA,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,5,2) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,7,2) FECHA_ENTREGA,
           ALIAS_0.NUMERODOCUMENTO NUMERODOCUMENTO,
           ALIAS_0.NOMBREORIGINANTETR NOMBREORIGINANTETR,
           ALIAS_0.NOMBREDESTINATARIOTR NOMBREDESTINATARIOTR,
           ALIAS_6.NOMBRE MONEDA,
           ALIAS_0.COTIZACION COTIZACION,
           ALIAS_1.CODIGO CODIGO,
           ALIAS_9.CODIGO CODIGOCC,
           ALIAS_9.DESCRIPCION CONCEPTOCOMERCIAL,
           ALIAS_1.DESCRIPCION DESCRIPCION,
           ALIAS_1.AFECTASTOCK AFECTASTOCK,
           ALIAS_0.CANTIDAD2_CANTIDAD CANTIDAD,
           ALIAS_0.CNOLINEAL2_CANTIDAD CANTIDAD_NL,
           ALIAS_0.VALOR2_IMPORTE PRECIO,
           ALIAS_0.IMPORTEBONIFICADO IMPORTE_BONIFICADO,
           ALIAS_0.TOTAL2_IMPORTE TOTAL_IMPORTE,
        gv.descripcion as origen,
        seg.nombre5 as color

    FROM V_ITEMVENTA ALIAS_0
    LEFT OUTER JOIN V_TIPOTRANSACCION ALIAS_1 ON ALIAS_0.TIPOTRANSACCION_ID = ALIAS_1.ID
    LEFT OUTER JOIN V_SUBSUCURSAL ALIAS_2 ON ALIAS_0.SUBSUCURSAL_ID = ALIAS_2.ID
    LEFT OUTER JOIN V_SUCURSAL ALIAS_17 ON ALIAS_2.SUCURSAL_ID = ALIAS_17.ID
    LEFT OUTER JOIN V_FILIAL ALIAS_3 ON ALIAS_17.FILIAL_ID = ALIAS_3.ID
    LEFT OUTER JOIN V_TRVENTA ALIAS_5 ON ALIAS_0.PLACEOWNER_ID = ALIAS_5.ID
    LEFT OUTER JOIN V_DOMICILIO ALIAS_4 ON ALIAS_5.DOMICILIOENTREGA_ID = ALIAS_4.ID
    LEFT OUTER JOIN V_PROVINCIA ALIAS_13 ON ALIAS_4.PROVINCIA_ID = ALIAS_13.ID
    LEFT OUTER JOIN V_CIUDAD ALIAS_14 ON ALIAS_4.CIUDAD_ID = ALIAS_14.ID
    LEFT OUTER JOIN V_PAIS ALIAS_15 ON ALIAS_4.PAIS_ID = ALIAS_15.ID
    LEFT OUTER JOIN V_MONEDA ALIAS_6 ON ALIAS_5.MONEDA_ID = ALIAS_6.ID
    LEFT OUTER JOIN V_FLAG ALIAS_7 ON ALIAS_5.FLAG_ID = ALIAS_7.ID
    LEFT OUTER JOIN V_TREXTENSION ALIAS_18 ON ALIAS_5.TREXTENSION_ID = ALIAS_18.ID
    LEFT OUTER JOIN V_ESQUEMAOPERATIVO ALIAS_8 ON ALIAS_18.ESQUEMAOPERATIVO_ID = ALIAS_8.ID
    LEFT OUTER JOIN V_PROYECTO ALIAS_11 ON ALIAS_5.PROYECTO_ID = ALIAS_11.ID
    LEFT OUTER JOIN V_TIPOPAGO ALIAS_16 ON ALIAS_5.TIPOPAGO_ID = ALIAS_16.ID
    LEFT OUTER JOIN V_PROYECTO ALIAS_12 ON ALIAS_0.PROYECTO_ID = ALIAS_12.ID
    LEFT OUTER JOIN V_CONCEPTOCOMERCIAL ALIAS_9 ON ALIAS_0.REFERENCIA_ID = ALIAS_9.ID
    LEFT OUTER JOIN V_CENTROCOSTOS ALIAS_10 ON ALIAS_0.CENTROCOSTOS_ID = ALIAS_10.ID
left outer join producto b on ALIAS_0.nombrereferencia = b.codigo
left join segmento seg on b.segmento_id = seg.id
    LEFT OUTER JOIN (select id, boextension_id from V_TRFACTURAVENTA
               union
            select id, boextension_id from v_trcreditoventa
                union
            select id, boextension_id from v_trpresupuestoventa
                union
            select id, boextension_id from v_trordenventa) TRF ON TRF.ID = ALIAS_0.PLACEOWNER_ID

        LEFT OUTER JOIN (select id, origenfv_id from UD_TRFACTURAVENTA
                    union
                select id, origennc_id from UD_TRNOTACREDITO
                    union
                select id, origenant_id from ud_tranticipo
                    union
                select id, origenfm_id from UD_TRFACTURAVENTAMOS
                    union
                select id, origenpsp_id from UD_TRPRESUPUESTOVENTA
                    union
                select id, origennv_id from UD_NOTAVENTA) UD ON TRF.BOEXTENSION_ID = UD.ID

        left outer join grupovistas GV on GV.id = UD.origenFV_id

    WHERE ALIAS_0.PLACEOWNER_ID IS NOT NULL

/*  and substring(alias_0.fechadocumento,1,8) >= substring(${fechaDesde},1,8)
  and substring(alias_0.fechadocumento,1,8)<= substring(${fechaHasta},1,8)
*/
      and substring(alias_0.fechadocumento,1,8) >= substring('20180101',1,8)
      and substring(alias_0.fechadocumento,1,8) <= substring('20180131',1,8)

      AND (ALIAS_0.ESTADOTR = 'C')
      AND ALIAS_0.BO_PLACE_ID IS NOT NULL


     and alias_1.codigo not like 'VT05;RES-;tt-'
     and alias_1.codigo not like 'VT02'
     and alias_1.codigo not like 'VT01'
     and alias_1.codigo not like 'VT10;RES-;'
     and alias_1.codigo not like 'VT09;RES+;'
     and alias_1.codigo not like 'VT06;VENTAS-;RES-;'
     and alias_1.codigo not like 'VT14'
     and alias_1.codigo not like 'VT03'

--notas de credito y comprobantes que restan a las facturas
 Union all

    SELECT ALIAS_0.NOMBRETR TRANSACCION,
           ALIAS_0.ESTADOTR ESTADO,
           ALIAS_7.DESCRIPCION FLAG,
            SUBSTRING(ALIAS_0.FECHADOCUMENTO,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,5,2) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,7,2) FECHA_DOCUMENTO,
            SUBSTRING(ALIAS_0.FECHAENTREGA,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,5,2) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,7,2) FECHA_ENTREGA,
           ALIAS_0.NUMERODOCUMENTO NUMERODOCUMENTO,
           ALIAS_0.NOMBREORIGINANTETR NOMBREORIGINANTETR,
           ALIAS_0.NOMBREDESTINATARIOTR NOMBREDESTINATARIOTR,
           ALIAS_6.NOMBRE MONEDA,
           ALIAS_0.COTIZACION COTIZACION,
           ALIAS_1.CODIGO CODIGO,
           ALIAS_9.CODIGO CODIGOCC,
           ALIAS_9.DESCRIPCION CONCEPTOCOMERCIAL,
           ALIAS_1.DESCRIPCION DESCRIPCION,
           ALIAS_1.AFECTASTOCK AFECTASTOCK,
           ALIAS_0.CANTIDAD2_CANTIDAD CANTIDAD,
           ALIAS_0.CNOLINEAL2_CANTIDAD CANTIDAD_NL,
           -(ALIAS_0.VALOR2_IMPORTE) PRECIO,
           -(ALIAS_0.IMPORTEBONIFICADO) IMPORTE_BONIFICADO,
           -(ALIAS_0.TOTAL2_IMPORTE) TOTAL_IMPORTE,
          gv.descripcion as origen,
seg.nombre5 as color

    FROM V_ITEMVENTA ALIAS_0
    LEFT OUTER JOIN V_TIPOTRANSACCION ALIAS_1 ON ALIAS_0.TIPOTRANSACCION_ID = ALIAS_1.ID
    LEFT OUTER JOIN V_SUBSUCURSAL ALIAS_2 ON ALIAS_0.SUBSUCURSAL_ID = ALIAS_2.ID
    LEFT OUTER JOIN V_SUCURSAL ALIAS_17 ON ALIAS_2.SUCURSAL_ID = ALIAS_17.ID
    LEFT OUTER JOIN V_FILIAL ALIAS_3 ON ALIAS_17.FILIAL_ID = ALIAS_3.ID
    LEFT OUTER JOIN V_TRVENTA ALIAS_5 ON ALIAS_0.PLACEOWNER_ID = ALIAS_5.ID
    LEFT OUTER JOIN V_DOMICILIO ALIAS_4 ON ALIAS_5.DOMICILIOENTREGA_ID = ALIAS_4.ID
    LEFT OUTER JOIN V_PROVINCIA ALIAS_13 ON ALIAS_4.PROVINCIA_ID = ALIAS_13.ID
    LEFT OUTER JOIN V_CIUDAD ALIAS_14 ON ALIAS_4.CIUDAD_ID = ALIAS_14.ID
    LEFT OUTER JOIN V_PAIS ALIAS_15 ON ALIAS_4.PAIS_ID = ALIAS_15.ID
    LEFT OUTER JOIN V_MONEDA ALIAS_6 ON ALIAS_5.MONEDA_ID = ALIAS_6.ID
    LEFT OUTER JOIN V_FLAG ALIAS_7 ON ALIAS_5.FLAG_ID = ALIAS_7.ID
    LEFT OUTER JOIN V_TREXTENSION ALIAS_18 ON ALIAS_5.TREXTENSION_ID = ALIAS_18.ID
    LEFT OUTER JOIN V_ESQUEMAOPERATIVO ALIAS_8 ON ALIAS_18.ESQUEMAOPERATIVO_ID = ALIAS_8.ID
    LEFT OUTER JOIN V_PROYECTO ALIAS_11 ON ALIAS_5.PROYECTO_ID = ALIAS_11.ID
    LEFT OUTER JOIN V_TIPOPAGO ALIAS_16 ON ALIAS_5.TIPOPAGO_ID = ALIAS_16.ID
    LEFT OUTER JOIN V_PROYECTO ALIAS_12 ON ALIAS_0.PROYECTO_ID = ALIAS_12.ID
    LEFT OUTER JOIN V_CONCEPTOCOMERCIAL ALIAS_9 ON ALIAS_0.REFERENCIA_ID = ALIAS_9.ID
    LEFT OUTER JOIN V_CENTROCOSTOS ALIAS_10 ON ALIAS_0.CENTROCOSTOS_ID = ALIAS_10.ID
left outer join producto b on ALIAS_0.nombrereferencia = b.codigo
left join segmento seg on b.segmento_id = seg.id
    LEFT OUTER JOIN (select id, boextension_id from V_TRFACTURAVENTA
               union
            select id, boextension_id from v_trcreditoventa
                union
            select id, boextension_id from v_trpresupuestoventa
                union
            select id, boextension_id from v_trordenventa) TRF ON TRF.ID = ALIAS_0.PLACEOWNER_ID

        LEFT OUTER JOIN (select id, origenfv_id from UD_TRFACTURAVENTA
                    union
                select id, origennc_id from UD_TRNOTACREDITO
                    union
                select id, origenant_id from ud_tranticipo
                    union
                select id, origenfm_id from UD_TRFACTURAVENTAMOS
                    union
                select id, origenpsp_id from UD_TRPRESUPUESTOVENTA
                    union
                select id, origennv_id from UD_NOTAVENTA) UD ON TRF.BOEXTENSION_ID = UD.ID

        left outer join grupovistas GV on GV.id = UD.origenFV_id

    WHERE ALIAS_0.PLACEOWNER_ID IS NOT NULL

    and substring(alias_0.fechadocumento,1,8) >= substring(${fechaDesde},1,8)
    and substring(alias_0.fechadocumento,1,8)<= substring(${fechaHasta},1,8)

--    and substring(alias_0.fechadocumento,1,8) >= substring('20180101',1,8)
--    and substring(alias_0.fechadocumento,1,8) <= substring('20180131',1,8)


      AND (ALIAS_0.ESTADOTR = 'C')
      AND ALIAS_0.BO_PLACE_ID IS NOT NULL


 and alias_1.codigo not like 'VT13;VENTAS+;RES+;'
 and alias_1.codigo not like 'VT03;VENTAS+;RES+;'
 and alias_1.codigo not like 'VT11;VENTAS+;RES+;'
 and alias_1.codigo not like 'VT04;RES+;'
 and alias_1.codigo not like 'VT02'
 and alias_1.codigo not like 'VT01'
 and alias_1.codigo not like 'VT10;RES-;'
 and alias_1.codigo not like 'VT09;RES+;'
 and alias_1.codigo not like 'VT14'
 and alias_1.codigo not like 'VT03'

--Presupuestos solo los que estan activos y pendientes

union all

SELECT ALIAS_0.NOMBRETR TRANSACCION,
           ALIAS_0.ESTADOTR ESTADO,
           ALIAS_7.DESCRIPCION FLAG,
           SUBSTRING(ALIAS_0.FECHADOCUMENTO,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,5,2) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,7,2) FECHA_DOCUMENTO,
           SUBSTRING(ALIAS_0.FECHAENTREGA,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,5,2) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,7,2) FECHA_ENTREGA,
           ALIAS_0.NUMERODOCUMENTO NUMERODOCUMENTO,
           ALIAS_0.NOMBREORIGINANTETR NOMBREORIGINANTETR,
           ALIAS_0.NOMBREDESTINATARIOTR NOMBREDESTINATARIOTR,
           ALIAS_6.NOMBRE MONEDA,
           ALIAS_0.COTIZACION COTIZACION,
           ALIAS_1.CODIGO CODIGO,
           ALIAS_9.CODIGO CODIGOCC,
           ALIAS_9.DESCRIPCION CONCEPTOCOMERCIAL,
           ALIAS_1.DESCRIPCION DESCRIPCION,
           ALIAS_1.AFECTASTOCK AFECTASTOCK,
           ALIAS_0.CANTIDAD2_CANTIDAD CANTIDAD,
           ALIAS_0.CNOLINEAL2_CANTIDAD CANTIDAD_NL,
           ALIAS_0.VALOR2_IMPORTE PRECIO,
           ALIAS_0.IMPORTEBONIFICADO IMPORTE_BONIFICADO,
           ALIAS_0.TOTAL2_IMPORTE TOTAL_IMPORTE,
          gv.descripcion as origen,
seg.nombre5 as color

    FROM V_ITEMVENTA ALIAS_0
    LEFT OUTER JOIN V_TIPOTRANSACCION ALIAS_1 ON ALIAS_0.TIPOTRANSACCION_ID = ALIAS_1.ID
    LEFT OUTER JOIN V_SUBSUCURSAL ALIAS_2 ON ALIAS_0.SUBSUCURSAL_ID = ALIAS_2.ID
    LEFT OUTER JOIN V_SUCURSAL ALIAS_17 ON ALIAS_2.SUCURSAL_ID = ALIAS_17.ID
    LEFT OUTER JOIN V_FILIAL ALIAS_3 ON ALIAS_17.FILIAL_ID = ALIAS_3.ID
    LEFT OUTER JOIN V_TRVENTA ALIAS_5 ON ALIAS_0.PLACEOWNER_ID = ALIAS_5.ID
    LEFT OUTER JOIN V_DOMICILIO ALIAS_4 ON ALIAS_5.DOMICILIOENTREGA_ID = ALIAS_4.ID
    LEFT OUTER JOIN V_PROVINCIA ALIAS_13 ON ALIAS_4.PROVINCIA_ID = ALIAS_13.ID
    LEFT OUTER JOIN V_CIUDAD ALIAS_14 ON ALIAS_4.CIUDAD_ID = ALIAS_14.ID
    LEFT OUTER JOIN V_PAIS ALIAS_15 ON ALIAS_4.PAIS_ID = ALIAS_15.ID
    LEFT OUTER JOIN V_MONEDA ALIAS_6 ON ALIAS_5.MONEDA_ID = ALIAS_6.ID
    LEFT OUTER JOIN V_FLAG ALIAS_7 ON ALIAS_5.FLAG_ID = ALIAS_7.ID
    LEFT OUTER JOIN V_TREXTENSION ALIAS_18 ON ALIAS_5.TREXTENSION_ID = ALIAS_18.ID
    LEFT OUTER JOIN V_ESQUEMAOPERATIVO ALIAS_8 ON ALIAS_18.ESQUEMAOPERATIVO_ID = ALIAS_8.ID
    LEFT OUTER JOIN V_PROYECTO ALIAS_11 ON ALIAS_5.PROYECTO_ID = ALIAS_11.ID
    LEFT OUTER JOIN V_TIPOPAGO ALIAS_16 ON ALIAS_5.TIPOPAGO_ID = ALIAS_16.ID
    LEFT OUTER JOIN V_PROYECTO ALIAS_12 ON ALIAS_0.PROYECTO_ID = ALIAS_12.ID
    LEFT OUTER JOIN V_CONCEPTOCOMERCIAL ALIAS_9 ON ALIAS_0.REFERENCIA_ID = ALIAS_9.ID
    LEFT OUTER JOIN V_CENTROCOSTOS ALIAS_10 ON ALIAS_0.CENTROCOSTOS_ID = ALIAS_10.ID
left outer join producto b on ALIAS_0.nombrereferencia = b.codigo
left join segmento seg on b.segmento_id = seg.id
    LEFT OUTER JOIN (select id, boextension_id from V_TRFACTURAVENTA
               union
            select id, boextension_id from v_trcreditoventa
                union
            select id, boextension_id from v_trpresupuestoventa
                union
            select id, boextension_id from v_trordenventa) TRF ON TRF.ID = ALIAS_0.PLACEOWNER_ID

        LEFT OUTER JOIN (select id, origenfv_id from UD_TRFACTURAVENTA
                    union
                select id, origennc_id from UD_TRNOTACREDITO
                    union
                select id, origenant_id from ud_tranticipo
                    union
                select id, origenfm_id from UD_TRFACTURAVENTAMOS
                    union
                select id, origenpsp_id from UD_TRPRESUPUESTOVENTA
                    union
                select id, origennv_id from UD_NOTAVENTA) UD ON TRF.BOEXTENSION_ID = UD.ID

        left outer join grupovistas GV on GV.id = UD.origenFV_id

    WHERE ALIAS_0.PLACEOWNER_ID IS NOT NULL

  and substring(alias_0.fechadocumento,1,8) >= substring(${fechaDesde},1,8)
  and substring(alias_0.fechadocumento,1,8)<= substring(${fechaHasta},1,8)

    --   and substring(alias_0.fechadocumento,1,8) >= substring('20180101',1,8)
    --   and substring(alias_0.fechadocumento,1,8) <= substring('20180131',1,8)

      AND (ALIAS_0.ESTADOTR = 'A' or ALIAS_0.ESTADOTR = 'C')
      AND ALIAS_0.BO_PLACE_ID IS NOT NULL


     and alias_1.codigo not like 'VT05;RES-;tt-' --Nota de Credito--
     and alias_1.codigo not like 'VT02'  --Nota de Venta--
     and alias_1.codigo not like 'VT01'
     and alias_1.codigo not like 'VT10;RES-;' --Nota de credito de venta interna--
     and alias_1.codigo not like 'VT09;RES+;'  --Nota de Debito de Venta Interna--
     and alias_1.codigo not like 'VT06;VENTAS-;RES-;' --Factura Anulada--
     and alias_1.codigo not like 'VT14'
     --and alias_1.codigo not like 'VT03' --Preupuesto--
    and ALIAS_7.DESCRIPCION not like 'Anulada'
    and ALIAS_7.DESCRIPCION not like 'Licitacion'
    and alias_1.codigo not like 'VT13;VENTAS+;RES+;'
    and alias_1.codigo not like 'VT11;VENTAS+;RES+;'
    and alias_1.codigo not like 'VT04;RES+;'
    and alias_1.codigo not like 'VT03;VENTAS+;RES+;'


--order by alias_1.codigo, flag desc

--Notas de pedido Trae solo notas de pedido pendientes de entrega, no toma en cuenta NP saldadas.

union all


SELECT ALIAS_0.NOMBRETR TRANSACCION,
           ALIAS_0.ESTADOTR ESTADO,
           ALIAS_7.DESCRIPCION FLAG,
           SUBSTRING(ALIAS_0.FECHADOCUMENTO,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,5,2) ||'/'|| SUBSTRING(ALIAS_0.FECHADOCUMENTO,7,2) FECHA_DOCUMENTO,
           SUBSTRING(ALIAS_0.FECHAENTREGA,1,4) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,5,2) ||'/'|| SUBSTRING(ALIAS_0.FECHAENTREGA,7,2) FECHA_ENTREGA,
           ALIAS_0.NUMERODOCUMENTO NUMERODOCUMENTO,
           ALIAS_0.NOMBREORIGINANTETR NOMBREORIGINANTETR,
           ALIAS_0.NOMBREDESTINATARIOTR NOMBREDESTINATARIOTR,
           ALIAS_6.NOMBRE MONEDA,
           ALIAS_0.COTIZACION COTIZACION,
           ALIAS_1.CODIGO CODIGO,
           ALIAS_9.CODIGO CODIGOCC,
           ALIAS_9.DESCRIPCION CONCEPTOCOMERCIAL,
           ALIAS_1.DESCRIPCION DESCRIPCION,
           ALIAS_1.AFECTASTOCK AFECTASTOCK,
           ALIAS_0.CANTIDAD2_CANTIDAD CANTIDAD,
           ALIAS_0.CNOLINEAL2_CANTIDAD CANTIDAD_NL,
           ALIAS_0.VALOR2_IMPORTE PRECIO,
           ALIAS_0.IMPORTEBONIFICADO IMPORTE_BONIFICADO,
           ALIAS_0.TOTAL2_IMPORTE TOTAL_IMPORTE,
          gv.descripcion as origen,
seg.nombre5 as color/*,
        Case when p.saldada = 'F' then 'Pendiente'
        else 'entregado'
        end as prueba
          */

    FROM V_ITEMVENTA ALIAS_0
    LEFT OUTER JOIN pendiente p on alias_0.placeowner_id = p.transaccion_id
    LEFT OUTER JOIN V_TIPOTRANSACCION ALIAS_1 ON ALIAS_0.TIPOTRANSACCION_ID = ALIAS_1.ID
    LEFT OUTER JOIN V_SUBSUCURSAL ALIAS_2 ON ALIAS_0.SUBSUCURSAL_ID = ALIAS_2.ID
    LEFT OUTER JOIN V_SUCURSAL ALIAS_17 ON ALIAS_2.SUCURSAL_ID = ALIAS_17.ID
    LEFT OUTER JOIN V_FILIAL ALIAS_3 ON ALIAS_17.FILIAL_ID = ALIAS_3.ID
    LEFT OUTER JOIN V_TRVENTA ALIAS_5 ON ALIAS_0.PLACEOWNER_ID = ALIAS_5.ID
    LEFT OUTER JOIN V_DOMICILIO ALIAS_4 ON ALIAS_5.DOMICILIOENTREGA_ID = ALIAS_4.ID
    LEFT OUTER JOIN V_PROVINCIA ALIAS_13 ON ALIAS_4.PROVINCIA_ID = ALIAS_13.ID
    LEFT OUTER JOIN V_CIUDAD ALIAS_14 ON ALIAS_4.CIUDAD_ID = ALIAS_14.ID
    LEFT OUTER JOIN V_PAIS ALIAS_15 ON ALIAS_4.PAIS_ID = ALIAS_15.ID
    LEFT OUTER JOIN V_MONEDA ALIAS_6 ON ALIAS_5.MONEDA_ID = ALIAS_6.ID
    LEFT OUTER JOIN V_FLAG ALIAS_7 ON ALIAS_5.FLAG_ID = ALIAS_7.ID
    LEFT OUTER JOIN V_TREXTENSION ALIAS_18 ON ALIAS_5.TREXTENSION_ID = ALIAS_18.ID
    LEFT OUTER JOIN V_ESQUEMAOPERATIVO ALIAS_8 ON ALIAS_18.ESQUEMAOPERATIVO_ID = ALIAS_8.ID
    LEFT OUTER JOIN V_PROYECTO ALIAS_11 ON ALIAS_5.PROYECTO_ID = ALIAS_11.ID
    LEFT OUTER JOIN V_TIPOPAGO ALIAS_16 ON ALIAS_5.TIPOPAGO_ID = ALIAS_16.ID
    LEFT OUTER JOIN V_PROYECTO ALIAS_12 ON ALIAS_0.PROYECTO_ID = ALIAS_12.ID
    LEFT OUTER JOIN V_CONCEPTOCOMERCIAL ALIAS_9 ON ALIAS_0.REFERENCIA_ID = ALIAS_9.ID
    LEFT OUTER JOIN V_CENTROCOSTOS ALIAS_10 ON ALIAS_0.CENTROCOSTOS_ID = ALIAS_10.ID
left outer join producto b on ALIAS_0.nombrereferencia = b.codigo
left join segmento seg on b.segmento_id = seg.id
    LEFT OUTER JOIN (select id, boextension_id from V_TRFACTURAVENTA
               union
            select id, boextension_id from v_trcreditoventa
                union
            select id, boextension_id from v_trpresupuestoventa
                union
            select id, boextension_id from v_trordenventa) TRF ON TRF.ID = ALIAS_0.PLACEOWNER_ID

        LEFT OUTER JOIN (select id, origenfv_id from UD_TRFACTURAVENTA
                    union
                select id, origennc_id from UD_TRNOTACREDITO
                    union
                select id, origenant_id from ud_tranticipo
                    union
                select id, origenfm_id from UD_TRFACTURAVENTAMOS
                    union
                select id, origenpsp_id from UD_TRPRESUPUESTOVENTA
                    union
                select id, origennv_id from UD_NOTAVENTA) UD ON TRF.BOEXTENSION_ID = UD.ID

        left outer join grupovistas GV on GV.id = UD.origenFV_id

    WHERE ALIAS_0.PLACEOWNER_ID IS NOT NULL

  and substring(alias_0.fechadocumento,1,8) >= substring(${fechaDesde},1,8)
  and substring(alias_0.fechadocumento,1,8)<= substring(${fechaHasta},1,8)

    --   and substring(alias_0.fechadocumento,1,8) >= substring('20180101',1,8)
    --   and substring(alias_0.fechadocumento,1,8) <= substring('20180131',1,8)

    AND (ALIAS_0.ESTADOTR = 'C')
    AND ALIAS_0.BO_PLACE_ID IS NOT NULL
    AND (p.saldada = 'F')
    AND TIPOTRGENERAR_ID ='89C23593-3F01-11D5-86AD-0080AD403F5F'



     and alias_1.codigo not like 'VT05;RES-;tt-' --Nota de Credito--
     --and alias_1.codigo not like 'VT02'  --Nota de Venta--
     and alias_1.codigo not like 'VT01'
     and alias_1.codigo not like 'VT10;RES-;' --Nota de credito de venta interna--
     and alias_1.codigo not like 'VT09;RES+;'  --Nota de Debito de Venta Interna--
     and alias_1.codigo not like 'VT06;VENTAS-;RES-;' --Factura Anulada--
     and alias_1.codigo not like 'VT14'
     and alias_1.codigo not like 'VT03' --Preupuesto--


    and ALIAS_7.DESCRIPCION not like 'Anulada'
    and ALIAS_7.DESCRIPCION not like 'Licitacion'
    and alias_1.codigo not like 'VT13;VENTAS+;RES+;'
    and alias_1.codigo not like 'VT11;VENTAS+;RES+;'
    and alias_1.codigo not like 'VT04;RES+;'
    and alias_1.codigo not like 'VT03;VENTAS+;RES+;'

group by codigocc,
ALIAS_0.NOMBRETR,
ALIAS_0.ESTADOTR,
ALIAS_7.DESCRIPCION,
ALIAS_0.FECHADOCUMENTO,
ALIAS_0.FECHAENTREGA,
ALIAS_0.NUMERODOCUMENTO ,
           ALIAS_0.NOMBREORIGINANTETR ,
           ALIAS_0.NOMBREDESTINATARIOTR ,
           ALIAS_6.NOMBRE ,
           ALIAS_0.COTIZACION ,
           ALIAS_1.CODIGO ,
           ALIAS_9.DESCRIPCION ,
           ALIAS_1.DESCRIPCION ,
           ALIAS_1.AFECTASTOCK ,
           ALIAS_0.CANTIDAD2_CANTIDAD ,
           ALIAS_0.CNOLINEAL2_CANTIDAD ,
           ALIAS_0.VALOR2_IMPORTE ,
           ALIAS_0.IMPORTEBONIFICADO ,
           ALIAS_0.TOTAL2_IMPORTE ,
          gv.descripcion,
          seg.nombre5

order by transaccion