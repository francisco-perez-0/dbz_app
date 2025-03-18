package com.francisco.profileProject.controllers;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.UriComponentsBuilder;

import com.francisco.profileProject.models.Card;
import com.francisco.profileProject.models.UserCard;
import com.francisco.profileProject.models.UserProfile;
import com.francisco.profileProject.repositories.CardRepository;
import com.francisco.profileProject.repositories.UserCardRepository;
import com.francisco.profileProject.repositories.UserProfileRepository;
import com.francisco.profileProject.services.JwtUtil;

import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.boot.autoconfigure.security.SecurityProperties.User;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.net.URI;
import java.net.http.HttpResponse.ResponseInfo;
import java.nio.file.AccessDeniedException;
import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.PrimitiveIterator;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


@RestController

public class ProfileController {

    private final UserProfileRepository userProfileRepository;
    private final UserCardRepository userCardRepository;
    private final PasswordEncoder passwordEncoder;
    private final CardRepository cardRepository;
    private final JwtUtil jwtUtil;
    @Autowired //DI
    public ProfileController(UserProfileRepository userProfileRepository, PasswordEncoder passwordEncoder, 
                            JwtUtil jwtUtil, UserCardRepository userCardRepository, CardRepository cardRepository ) {
        this.userProfileRepository = userProfileRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtil = jwtUtil;
        this.userCardRepository = userCardRepository;
        this.cardRepository = cardRepository;
    }
    @PostMapping("/register")
    public ResponseEntity<Void> registerUser(@RequestBody UserProfile up, UriComponentsBuilder ucb) {
        if( up.getUsername() == null | up.getUsername().isEmpty()){
            throw new IllegalArgumentException("El nombre de usuario es requerido");
        }
        if( up.getPassword() == null | up.getPassword().isEmpty() ){
            throw new IllegalArgumentException("La contraseña es requerida");
        }
        if( up.getEmail() == null | up.getEmail().isEmpty()){
            throw new IllegalArgumentException("El email es requerido");
        }
        if(userProfileRepository.existsByEmail(up.getEmail())){
            throw new IllegalArgumentException("Ya existe este email");
        }
        if(userProfileRepository.existsByUsername(up.getUsername())){
            throw new IllegalArgumentException("El nombre de usuario ya existe");
        }
        up.setPassword(passwordEncoder.encode(up.getPassword()));
        up.setRole("USER");
        System.out.println("Guardando usuario...");
        UserProfile savedUser = userProfileRepository.save(up);
        System.out.println("Usuario guardado con ID: " + savedUser.getId());
        URI location = ucb
                        .path("/profiles/{id}")
                        .buildAndExpand(savedUser.getId())
                        .toUri();
        return ResponseEntity.created(location).build();

    }
    @ExceptionHandler(IllegalArgumentException.class)
        public ResponseEntity<String> handleIllegalArgumentException(IllegalArgumentException e){
            return ResponseEntity.badRequest().body(e.getMessage());
        }

    //Solo el admin puede ver este endpoint
    @GetMapping("/profiles")
    public ResponseEntity<List<UserProfile>> getAllProfiles() {
        List<UserProfile> profiles = userProfileRepository.findAll();
        return ResponseEntity.ok(profiles);
    }

    @GetMapping("/profiles/{id}")
    public ResponseEntity<UserProfile> getProfileById(@PathVariable Long id, Principal principal) throws AccessDeniedException {
        String authenticatedUsername = principal.getName();
        UserProfile up = userProfileRepository.findById(id)
                        .orElseThrow(() -> new IllegalArgumentException("Usuario no encontrado"));
        if(!up.getUsername().equals(authenticatedUsername)){
            throw new AccessDeniedException("No tienes permiso para ver este perfil");
        }
        return ResponseEntity.ok(up);
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<String> handleAccessDeniedException(AccessDeniedException e){
        return ResponseEntity.badRequest().body(e.getMessage());
    }
    //Obtener mi informacion
    @GetMapping("/profiles/me")
    public ResponseEntity<UserProfile> getMethodName(Principal principal) {
        String username = principal.getName();
        UserProfile userProfile = userProfileRepository.findByUsername(username);
        return ResponseEntity.ok(userProfile);
    }


    @PostMapping("/login")
    public ResponseEntity<Map<String,String>> login(@RequestBody Map<String,String> credentials) {
        String username = credentials.get("username");
        String pass = credentials.get("password");
        UserProfile up = userProfileRepository.findByUsername(username);
        if(up == null || !passwordEncoder.matches(pass, up.getPassword())){
            throw new IllegalArgumentException("Credenciales invalidas");
        }
        String token = jwtUtil.generateToken(username, up.getRole());
        Map<String, String> response = new HashMap<>();
        response.put("token", token);
        response.put("id", up.getId().toString());
        return ResponseEntity.ok(response);
    }
    //Genera la relacion user-carta para cuando un usuario obtiene una carta
    //No checkea si la carta existe en la BBDD porque el front siempre manda un id existente (cambiar luego)
    @PostMapping("/profile/me/savecard")
    public ResponseEntity<Void> saveCard(@RequestBody Long idCard, Principal principal) {
        String username = principal.getName();
        Card card = cardRepository.findById(idCard)
            .orElseThrow(() -> new IllegalArgumentException("Carta no encontrada"));
        UserProfile up = userProfileRepository.findByUsername(username);
        UserCard uc = new UserCard(up, card, LocalDateTime.now());
        userCardRepository.save(uc);
        return ResponseEntity.ok().build();
    }


}
