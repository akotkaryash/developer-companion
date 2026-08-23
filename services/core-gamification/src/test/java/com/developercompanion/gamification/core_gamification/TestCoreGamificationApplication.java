package com.developercompanion.gamification.core_gamification;

import org.springframework.boot.SpringApplication;

public class TestCoreGamificationApplication {

	public static void main(String[] args) {
		SpringApplication.from(CoreGamificationApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
