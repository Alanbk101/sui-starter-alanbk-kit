module 0xf4d0dd5f0411::alanbk {
    use std::debug::print;
    use std::string::{String, utf8};

    public struct Usuario has drop, store {
        nombre: String,
        edad: u8,
        vivo: bool,
    }
 
    fun practica(usuario: Usuario) {
        if (usuario.edad > 18) {
            print(&utf8(b"Acceso permitido"));
        } else if (usuario.edad == 18) {
            print(&utf8(b"Bien lo lograste!"));
        } else {
            print(&utf8(b"Acceso No permitido"));
        }
    }

    #[test]
    fun prueba() {
        let usuario = Usuario {
            nombre: utf8(b"Aldo Perez"),
            edad: 28,
            vivo: true, 
        };

        practica(usuario);
    }
}
