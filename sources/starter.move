module cajafuerte::registro_cajafuerte{
use std::string::String;
use sui::vec_map::{Self, VecMap};


public struct CajaFuerte has key, store {
    id: UID,
    nombre_cajaFuerte: String,
    clientes: VecMap<u64, Cliente>,
 }


public struct Cliente has copy, drop, store {
    nombre_dueno: String,
    objetos: vector<Objeto>,
 }

public enum Objeto has store, drop, copy {
    Oro(Oro),
    Plata(Plata),
}

public struct Oro has copy, drop, store {
    nombre: String,
    cantidad: String,
    valor: u8

}



public struct Plata has copy, drop, store {
    nombre: String,
    cantidad: String,
    valor: u8
 }

 #[error]
 const ID_YA_EXISTE: vector<u8> = b"ERROR el id ya existe";
 #[error]
 const ID_NO_EXISTE: vector<u8> = b"ERROR el id no existe";

public fun crear_cajafuerte(nombre: String, ctx: &mut TxContext) { 

    let cajaFuerte = CajaFuerte {
        id: object::new(ctx),
        nombre_cajaFuerte: nombre,
        clientes: vec_map::empty()
    };

    transfer::transfer(cajaFuerte, tx_context::sender(ctx));

 }

public fun agregar_cliente(cajaFuerte: &mut CajaFuerte, id_dueno: u64, nombre_dueno: String) {
    assert!(!cajaFuerte.clientes.contains(&id_dueno), ID_YA_EXISTE);

    let cliente = Cliente {
        nombre_dueno,
        objetos: vector []
    };

    cajaFuerte.clientes.insert(id_dueno, cliente);
 }

 public fun agregar_objeto(cajaFuerte: &mut CajaFuerte, id_dueno: u64, objeto: Objeto) {
    assert!(cajaFuerte.clientes.contains(&id_dueno), ID_NO_EXISTE);

    let cliente_ref = cajaFuerte.clientes.get_mut(&id_dueno);
    cliente_ref.objetos.push_back(objeto)

 }


}

    
