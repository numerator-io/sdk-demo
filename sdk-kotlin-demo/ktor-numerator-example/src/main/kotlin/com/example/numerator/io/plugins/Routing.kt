package com.example.numerator.io.plugins

import com.example.numerator.io.numerator.DefaultNumeratorFeatureFlag
import io.ktor.http.ContentType
import io.ktor.http.HttpHeaders
import io.ktor.server.application.*
import io.ktor.server.routing.*
import io.ktor.server.response.*

fun Application.configureRouting(flagProvider: DefaultNumeratorFeatureFlag) {
    routing {
        get("/land-pet") {
            if (flagProvider.isLandPetEnabled()) {
                val jsonString = "{\"land_pet\": \"true\"}"
                call.respondText(jsonString, ContentType.Application.Json)
            } else {
                val jsonString = "{\"land_pet\": \"false\"}"
                call.respondText(jsonString, ContentType.Application.Json)
            }
        }

        get("/rare-animal") {
            val guess = call.parameters["guess"]
            val context = if (guess != null) {
                mapOf("rare_animal" to guess)
            } else {
                emptyMap()
            }
            val jsonString = "{\"rare_animal\": \"${flagProvider.getRareAnimal(context)}\"}"
            call.respondText(jsonString, ContentType.Application.Json)
        }
    }
}