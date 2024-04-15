package com.example.numerator.io.numerator

import io.ktor.server.application.*
import io.numerator.client.NumeratorFeatureFlagProvider
import io.numerator.config.NumeratorConfig
import io.numerator.context.ContextProvider
import io.numerator.context.DefaultContextProvider
import io.numerator.polling.PollingModes

class DefaultNumeratorFeatureFlag(
    config: NumeratorConfig,
    contextProvider: ContextProvider?
) : NumeratorFeatureFlagProvider(config, contextProvider = contextProvider ?: DefaultContextProvider()) {

    @NumeratorBooleanFeatureFlag(key = "enable_land_pet", default = false)
    fun isLandPetEnabled(): Boolean {
        return getBooleanFeatureFlag(::isLandPetEnabled)
    }

    @NumeratorStringFeatureFlag(key = "rare_animal", default = "Not a rare animal")
    fun getRareAnimal(context: Map<String, Any>): String {
        return getStringFeatureFlag(::getRareAnimal, context)
    }

}

fun Application.configureNumerator(): DefaultNumeratorFeatureFlag {
    val numeratorConfig = NumeratorConfig.Builder()
        .apiKey("NUM.PbmFqVAzzHbUlieb1f51Fg==.5BsoRn9KBLCTMOiEmBxzX2hgEsP3raI61bXQ4dRKCXhzyzGNcyII+FWTUipNHi+E")
        .pollingConfig(PollingModes.autoPoll(6))
        .build()

    //Set Default Context
    val contextProvider = DefaultContextProvider()
    //contextProvider.set("supperman", true)

    val flagProvider = DefaultNumeratorFeatureFlag(numeratorConfig, contextProvider)
    flagProvider.addPollingFlagUpdatedListener() {
        println("Flag Updated")
    }
    flagProvider.addPollingFlagUpdatedErrorListener { error ->
        println("Error: $error")
    }
    return flagProvider
}