module caja_fuerte::digital {
    use sui::object;
    use sui::transfer;
    use sui::tx_context;
    use sui::vec_map::{Self, VecMap};
    use std::string::String;
    use std::vector;

    const ID_YA_EXISTE: u64 = 1;
    const ID_NO_EXISTE: u64 = 2;

    // Objeto principal con key y store para poder almacenar globalmente
    public struct CajaFuerteDigital has key, store {
        id: UID,
        clientes: VecMap<u64, Cliente>,
    }

    // Cliente con nombre del dueño y vector de cajas fuertes
    public struct Cliente has copy, drop, store {
        nombre_dueno: String,
        cajas_fuertes: vector<CajaFuerte>,
    }

    // Enum para estado de la caja fuerte
    public enum CajaFuerte {
        Disponible(Disponible),
        NoDisponible(NoDisponible),
    }

    // Estructura para cajas disponibles
    public struct Disponible has copy, drop, store {
        nombre: String,
        activo: bool,
        valor: u64,
    }

    // Estructura para cajas no disponibles
    public struct NoDisponible has copy, drop, store {
        nombre: String,
        activo: bool,
        valor: u64,
    }

    // Crear el objeto principal con clientes vacío
    public fun crear_caja_digital(ctx: &mut TxContext) {
        let clientes = vec_map::empty<u64, Cliente>();
        let caja_digital = CajaFuerteDigital {
            id: object::new(ctx),
            clientes,
        };
        transfer::transfer(caja_digital, tx_context::sender(ctx));
    }

    // Agregar un cliente nuevo; valida que no exista previamente
    public fun agregar_cliente(caja: &mut CajaFuerteDigital, id_dueno: u64, nombre: String) {
        assert!(!caja.clientes.contains(&id_dueno), ID_YA_EXISTE);
        let cliente = Cliente {
            nombre_dueno: nombre,
            cajas_fuertes: vector::empty(),
        };
        caja.clientes.insert(id_dueno, cliente);
    }

    // Agregar una caja fuerte a un cliente existente
    public fun agregar_caja(caja: &mut CajaFuerteDigital, id_dueno: u64, nueva_caja: CajaFuerte) {
        assert!(caja.clientes.contains(&id_dueno), ID_NO_EXISTE);
        let cliente = caja.clientes.get_mut(&id_dueno);
        vector::push_back(&mut cliente.cajas_fuertes, nueva_caja);
    }
}