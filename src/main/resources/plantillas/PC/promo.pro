
// PROMOCIONES GENERADAS CON VERSION DEL SISTEMA DE PLANTILLAS Nro: 1.23.001 - (30/06/09)

		// ************************ Inicializacion Promos PRE-PAGO ************************ //
Promotion prepago prepago_init
Parameters
	global wpurch = 0;
	global excluidos = {};
	global excluir = false;
	global beneficios = 0;
	global beneficiados = {};
	global tarjeta = "";
	global per = 0;
//	global dinero_ahorrado = 0;
	global primera_vez = true;

Benefits
	wpurch = $wholepurchase;
	excluidos = excluded;
	tarjeta = stringRNV(ram_cuenta_cliente);
	per = numRNV(ram_perfil);

		

  // ******  INICIO BLOQUE **************************************************************** //
  // ******  BLOQUE NAME = Bloque PREPAGO
  // ******  BLOQUE ID = 0
  // ******  CASH2BENEF =  1


//************** BLOQUE DE PROMOCIONES ********************
// Seccion Inicial

Promotion prepago bloque_seccion_inicial_0

// Description:

Parameters

	extern excluir;
		    
	extern excluidos;
	extern beneficios;
	extern beneficiados;
	global excluir_0 = false;


	  
  global benefits_otorgados_0_0 = 0;

  global benefits_otorgados_0_1 = 0;


Conditions


Benefits

	  

  skip;


  // ********  PROMOCIONES DEL BLOQUE 0 **************************************************** //


	  
		// ************************ CONFIGURACIONES MOTOR DE PROMOCIONES ************************ //
Promotion prepago global_config
Benefits
	numRNV(cupon_error) = 11;
	numRNV(cupon_vigencia) = 5;
	stringRNV(cupon_limite) = "10 de Octubre de 2007";


// FIN DE PROMO 0 del BLOQUE 0

Promotion prepago undo_0_0
Parameters
//	extern excluidos_0;
	extern excluidos;
Conditions
Benefits
//	excluded = excluidos_0;
	excluded = excluidos;
	skip;

// --- *** ---


	    
		

//********** Promoción Invel: Articulo Dispara Video *************

Promotion online articulo_dispara_video_0_1

PreConditions

	requireAny{(article x0_0000077901002,1)};

Parameters

	extern primera_vez;

	bolson = {(article x0_0000077901002,1)};
	arts = purchase meet bolson;


Conditions

	primera_vez;
	|arts| > 0;


Benefits

//	print("video.mpg");
	eproc (ivideo, "file=video.mpg");
	primera_vez = false;


Cancellation

Parameters
 b = false;

Conditions
 b;

Benefits
 skip;



// FIN DE PROMO 1 del BLOQUE 0

Promotion prepago undo_0_1
Parameters
//	extern excluidos_0;
	extern excluidos;
Conditions
Benefits
//	excluded = excluidos_0;
	excluded = excluidos;
	skip;

// --- *** ---


	    




  // ********  FIN BLOQUE 0 *************************************************************** //
//************** BLOOQUE DE PROMOCIONES ********************
// Seccion Final

Promotion prepago bloque_seccion_final_0

// Description: COMPITEN = false

Parameters

	extern excluir;
		    

	extern excluidos;
	extern beneficiados;
	extern beneficios;
//	extern per;
//	extern tarjeta;

	  
  global promo_activa_0_0 = false;
  extern benefits_otorgados_0_0;
	
					
  global promo_activa_0_1 = false;
  extern benefits_otorgados_0_1;
	
					

	// Parametros correspondientes a la promo articulo_dispara_video_0_1

	// -------------------------------- promo articulo_dispara_video_0_1

Conditions
// -----------------------------------------------

// -----------------------------------------------

Benefits


	// Promos NO Compiten - SUMANDO LOS BENEFICIOS DE TODAS

	benef = 0;
	  

	if benefits_otorgados_0_0 > 0 then
		promo_activa_0_0 = true;
		benef = benef + benefits_otorgados_0_0;
	else skip; fi;
		    

	if benefits_otorgados_0_1 > 0 then
		promo_activa_0_1 = true;
		benef = benef + benefits_otorgados_0_1;
	else skip; fi;
		    
	skip;
	// ----------------------------------------------------
	beneficios = benef;
	// -------------------------------------------------




// Aplicando los Beneficios que vienen por parametro

	if beneficios > 0 then
		excluir = true;
	else
		skip;
	fi;
				  		
// -------------------------------------------------




Promotion prepago fin_bloque_raiz_0
Parameters
			
	// Parametros correspondientes al bloque_0
	extern promo_activa_0_0;
	
					
	extern promo_activa_0_1;
	
					

	// Parametros correspondientes a la promo articulo_dispara_video_0_1

	// -------------------------------- promo articulo_dispara_video_0_1

	  

	// ---------- ---------------- -- bloque_0
	extern per;
	extern tarjeta;
//	extern dinero_ahorrado;

Benefits
			
	// Aplicando Beneficios correspondientes al bloque_0

// BENEFICIO -> COMPETENCIA = false
// Aplicando TODOS los Beneficios

		  
	if promo_activa_0_0 then
					
					
		skip;
	else skip; fi;

	    
	if promo_activa_0_1 then
					
					

	// Aplicando Beneficios correspondientes a la promo articulo_dispara_video_0_1

	// ------------------------------------------ promo articulo_dispara_video_0_1
		skip;
	else skip; fi;

	    
// -----------------------------


	// --------- ---------- ---------------- -- bloque_0
//	Si se acumularon descuentos, se imprime el mensaje apropiado.
//	if dinero_ahorrado > 0 then
//		if log(total, "REBAJADO UD. AHORRO $"++dinero_ahorrado) then skip; else skip; fi;
//	else skip; fi;
	

	skip;

		

  // ******  INICIO BLOQUE **************************************************************** //
  // ******  BLOQUE NAME = Bloque POSTPAGO
  // ******  BLOQUE ID = 1
  // ******  CASH2BENEF =  1


//************** BLOQUE DE PROMOCIONES ********************
// Seccion Inicial

Promotion postpago bloque_seccion_inicial_1

// Description:

Parameters

	extern excluir;
		    
	extern excluidos;
	extern beneficios;
	extern beneficiados;
	global excluir_1 = false;


	  

Conditions


Benefits

	  

  skip;


  // ********  PROMOCIONES DEL BLOQUE 1 **************************************************** //


	  




  // ********  FIN BLOQUE 1 *************************************************************** //
//************** BLOOQUE DE PROMOCIONES ********************
// Seccion Final

Promotion postpago bloque_seccion_final_1

// Description: COMPITEN = false

Parameters

	extern excluir;
		    

	extern excluidos;
	extern beneficiados;
	extern beneficios;
//	extern per;
//	extern tarjeta;

	  

Conditions
// -----------------------------------------------

// -----------------------------------------------

Benefits


	// Promos NO Compiten - SUMANDO LOS BENEFICIOS DE TODAS

	benef = 0;
	  
	skip;
	// ----------------------------------------------------
	beneficios = benef;
	// -------------------------------------------------




// Aplicando los Beneficios que vienen por parametro

	if beneficios > 0 then
		excluir = true;
	else
		skip;
	fi;
				  		
// -------------------------------------------------




Promotion postpago fin_bloque_raiz_1
Parameters
			
	// Parametros correspondientes al bloque_1

	  

	// ---------- ---------------- -- bloque_1
	extern per;
	extern tarjeta;
//	extern dinero_ahorrado;

Benefits
			
	// Aplicando Beneficios correspondientes al bloque_1

// BENEFICIO -> COMPETENCIA = false
// Aplicando TODOS los Beneficios

		  
// -----------------------------


	// --------- ---------- ---------------- -- bloque_1

	skip;

		