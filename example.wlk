class Criatura {
  var poderMagico
  const astucia
  var rol

  method poderMagico() = poderMagico

  method astucia() = astucia

  method rol() = rol

  method cambiarRol(unRol){
    rol = unRol
  }

  method poderOfensivo() = (poderMagico * 10) + rol.extra()

  method esAstuta()

  method esExtraordinaria() = rol.esExtraordinario(self)

  method esFormidable() = self.esAstuta() or self.esExtraordinaria()
  
  method cambiarRol() = rol.hacerRitual(self)

  method perderPoderMagico() {
    poderMagico = poderMagico * 0.85
  }
}

class Hada inherits Criatura {
  var cantKm = 2

  method aumentarCantidadKm(unKm) {
    cantKm = (cantKm + unKm).min(25)
  }

  override method esAstuta() = astucia > 50 

  override method esExtraordinaria() = super() and cantKm > 10
}

class Duende inherits Criatura {
  override method poderOfensivo() = super() * 1.10
  
  override method esAstuta() = false
}

object guardian {
  method extra() = 100
  
  method esExtraordinario(criatura) = criatura.poderMagico() > 50

  method hacerRitual(criatura) {
    const nuevaMascota = new MascotaMitologica(edad = 1, tieneCuernos = false)
    const nuevoDomador = new Domador()
    nuevoDomador.agregarMascota(nuevaMascota)
    criatura.cambiarRol(nuevoDomador)
  }
}

object hechicero {
  method extra() = 0
  
  method esExtraordinario(criatura) = true
  
  method hacerRitual(criatura) {
    criatura.cambiarRol(guardian)
  }
}

class Domador {
  const listaMascotaMitologica = []

  method agregarMascota(unaMascota) = listaMascotaMitologica.add(unaMascota)
  
  method cantMascotaConCuerno() = listaMascotaMitologica.count({ m => m.tieneCuernos() })
  
  method extra() = 150 * self.cantMascotaConCuerno()

  method sonTodasVeteranas() = listaMascotaMitologica.all({ m => m.esVeterana() })

  method esExtraordinario(criatura) = criatura.poderMagico() >= 15 and self.sonTodasVeteranas()
  
  method hacerRitual(criatura) {
    if (not listaMascotaMitologica.any({ m => m.tieneCuernos() })) {
      self.error("no se puede cambiar, se cancela")
    } else {
      criatura.cambiarRol(hechicero)
    }
  }
}

class MascotaMitologica {
  const edad
  const tieneCuernos

  method edad() = edad
  method tieneCuernos() = tieneCuernos

  method esVeterana() = edad >= 10
  
}

class Colonia {
  const criaturas = []

  method agregarCriatura(unaCriatura) = criaturas.add(unaCriatura)

  method poderOfensivoColonia() = criaturas.sum({ c => c.poderOfensivo() })
  
  method cantidadcriaturasFomidables() = criaturas.count({ c => c.esFormidable() })
  
  method sacarle15PoderMagicoCriaturas() = criaturas.forEach({ c => c.perderPoderMagico() })
}

class Area {
  const tipo
  const colonia

  method tipo() = tipo

  method colonia() = colonia

  method poderDefensivoArea()
  
  method esUsurpadaPorColoniaOfensiva(coloniaInvasora) = coloniaInvasora.poderOfensivoColonia() > self.poderDefensivoArea()

  method procesarConquista(coloniaInvasora) {
    if (not self.esUsurpadaPorColoniaOfensiva(coloniaInvasora)) {
      coloniaInvasora.sacarle15PoderMagicoCriaturas()
    }
  }
}

class Castillo inherits Area {
  override method poderDefensivoArea() = 200 * colonia.cantidadcriaturasFomidables()
}

class Claro inherits Area {
  override method poderDefensivoArea() = 100 + colonia.poderOfensivoColonia()
}