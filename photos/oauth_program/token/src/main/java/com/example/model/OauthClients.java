package com.example.model;

import java.io.Serializable;

public class OauthClients implements Serializable {
	private String clientId;
	private String clientSecret;
	private String clientName;
	public OauthClients(String clientId, String clientSecret, String clientName) {
		this.clientId = clientId;
		this.clientSecret = clientSecret;
		this.clientName = clientName;
	}
	public String getClient_Id() {
		return clientId;
	}
	public String getClient_Secret() {
		return clientSecret;
	}
	public String getClient_Name() {
		return clientName;
	}
}
