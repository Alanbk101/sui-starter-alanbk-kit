module starter::practica_sui;

use std::string::{String, utf8};

public struct Veterinaria has key {
    id: UID,
    nombre: String,
    mascotas: vector<Mascota>,
}

public struct Mascota has store, drop {
    nombre: String,
    edad: u16,
    especie: String,
    foto: String,
    estado: String,
}

#[error] 
const ID_NO_EXISTE: vector<u8> = b"El ID proporcionado no existe.";

public fun crear_veterinaria(nombre: String, ctx: &mut TxContext) {
    let veterinaria = Veterinaria { id: object::new(ctx), nombre, mascotas: vector[] };
    transfer::transfer(veterinaria, tx_context::sender(ctx));
}

public fun agregar_mascota(
    veterinaria: &mut Veterinaria, 
    nombre: String, 
    edad: u16, 
    especie: String, 
    foto: String) {
    
    let mascota = Mascota { nombre, edad, especie, foto, estado: utf8(b"Recién Admitido") };
    veterinaria.mascotas.push_back(mascota);
}

public fun eliminar_ultima_mascota(veterinaria: &mut Veterinaria) {
    veterinaria.mascotas.pop_back();
}

public fun eliminar_mascota(veterinaria: &mut Veterinaria, id: u64) {
    assert!(!(veterinaria.mascotas.length() > id), ID_NO_EXISTE);
    veterinaria.mascotas.remove(id);
}

public fun editar_estado(veterinaria: &mut Veterinaria, id: u64, estado: String) {
    assert!(!(veterinaria.mascotas.length() > id), ID_NO_EXISTE);
    let mascota = veterinaria.mascotas.borrow_mut(id);
    mascota.estado = estado;
}