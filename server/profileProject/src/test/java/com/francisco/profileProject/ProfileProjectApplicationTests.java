package com.francisco.profileProject;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.User;
import org.springframework.web.client.RestTemplate;

import com.francisco.profileProject.models.UserProfile;
import com.jayway.jsonpath.DocumentContext;
import com.jayway.jsonpath.JsonPath;
import static org.assertj.core.api.Assertions.assertThat;
import java.net.URI;
import java.util.HashMap;
import java.util.Map;


@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class ProfileProjectApplicationTests {
@Autowired
TestRestTemplate restTemplate; //Inyectar test helper para crear HTTP Request a la app corriendo local
@Test
void shouldCreateANewUser() {
    String uniqueUserName = "u_" + System.currentTimeMillis();
    String uniqueEmail = "e_" + System.currentTimeMillis();
    UserProfile up = new UserProfile(uniqueUserName, "1234", uniqueEmail, "", "");
    ResponseEntity<Void> createResponse = restTemplate.postForEntity("/register", up, Void.class);
    assertThat(createResponse.getStatusCode()).isEqualTo(HttpStatus.CREATED);

    Map<String, String> credentials = new HashMap<>();
    credentials.put("username", uniqueUserName);
    credentials.put("password", "1234");
    URI locationOfNewUser = createResponse.getHeaders().getLocation();
    ResponseEntity<Map> loginResponse = restTemplate.postForEntity("/login", credentials, Map.class);
    assertThat(loginResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
    String token = (String) loginResponse.getBody().get("token");
    System.out.println("Token generado: " + token);

    // GET /profiles/{id} con el token
    HttpHeaders headers = new HttpHeaders();
    headers.set("Authorization", "Bearer " + token);
    System.out.println("Header Authorization enviado: " + headers.getFirst("Authorization"));
    HttpEntity<String> entity = new HttpEntity<>(headers);
    ResponseEntity<String> getResponse = restTemplate.exchange(locationOfNewUser, HttpMethod.GET, entity, String.class);
    System.out.println("Status del GET: " + getResponse.getStatusCode());
    assertThat(getResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
}

	void shouldNotCreateANewUserIfEmailUsed(){
		UserProfile up = new UserProfile("Pacooo", "1111", "aa@a", "", "");
		ResponseEntity<Void> createResponse = restTemplate.postForEntity("/register", up, Void.class);
		assertThat(createResponse.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
	}
	void shouldNotCreateANewUserIfUsernameUsed(){
		UserProfile up = new UserProfile("Pacoo", "1111", "aa@aaaa", "", "");
		ResponseEntity<Void> createResponse = restTemplate.postForEntity("/register", up, Void.class);
		assertThat(createResponse.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
	}
	


}
