Promotion ever promoGlobal
    // Promocion inicial que se utiliza para definir todas
    // las variables globales iniciales, y cualquier
    // operacion que hiciese falta.
Parameters
    global excluded = {};
    global nopromotion = department nopromo;
    global buyed = {}; //buyed_articles; // todos los articulos comprados por el cliente
    global added = {}; // ultimo/s articulo/s tickeado/s
    global cancelled = {}; // ultimo/s articulo/s devuelto/s por el cliente
    global delivered = {}; //delivered_articles; // articulos entregados como beneficio de una promo
    global discounts = {}; //discounts_credits; // descuentos aplicados por credits

//    global wholepurchase = {};
//    global purchase = {};
    global wholepurchase = buyed + delivered + discounts;  // CUIDADO ESTO TIENE UN COMPORTAMIENTO PARTICULAR EN EL EVALUADOR
    global purchase = buyed - ( excluded union nopromotion); // CUIDADO ESTO TIENE UN COMPORTAMIENTO PARTICULAR EN EL EVALUADOR
    
Benefits
    added = added_articles;
    cancelled = {};
    buyed = buyed + added;

//    wholepurchase = buyed + delivered + discounts;
//    purchase = buyed - ( excluded union nopromotion);
    //print("un ejecucion GLOBAL completada.");
Cancellation
Parameters
    //static undo = 0;
Benefits
    added = {};
    cancelled = added_articles;
    buyed = buyed - cancelled;

//    wholepurchase = buyed  + delivered + discounts;
//    purchase = buyed - ( excluded union nopromotion);

    //undo = undo + 1;
    //print("Cantidad de anulaciones: "++undo);
    
