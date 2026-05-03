package com.example.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class AuthCodes implements Serializable {
	private String code;
	private String clientId;
	private Timestamp issuedAt;
	public AuthCodes(String code, String clientId, Timestamp issuedAt) {
		this.code = code;
		this.clientId = clientId;
		this.issuedAt = issuedAt;
	}
	public String getCode() {
		return code;
	}
	public String getClientId() {
		return clientId;
	}
	public Timestamp getIssuedAt() {
		return issuedAt;
	}
}
