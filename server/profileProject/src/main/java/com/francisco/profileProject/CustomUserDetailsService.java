package com.francisco.profileProject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.francisco.profileProject.models.UserProfile;
import com.francisco.profileProject.repositories.UserProfileRepository;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserProfileRepository userProfileRepository;

    @Autowired
    public CustomUserDetailsService(UserProfileRepository userProfileRepository) {
        this.userProfileRepository = userProfileRepository;
    }

    @Override
public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
    System.out.println("Intentando autenticar usuario: " + username);
    UserProfile userProfile = userProfileRepository.findByUsername(username);
    if (userProfile == null) {
        System.out.println("Usuario no encontrado: " + username);
        throw new UsernameNotFoundException("User not found: " + username);
    }
    System.out.println("Usuario encontrado - Username: " + userProfile.getUsername() +
                        ", Password: " + userProfile.getPassword() +
                        ", Rol: " + userProfile.getRole());
    try {
        return User
                .withUsername(userProfile.getUsername())
                .password(userProfile.getPassword())
                .roles(userProfile.getRole())
                .build();
    } catch (Exception e) {
        System.out.println("Error al construir UserDetails: " + e.getMessage());
        throw new UsernameNotFoundException("Failed to build user", e);
    }
}
}