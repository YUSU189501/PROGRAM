package com.example.model;

import com.example.dao.TokenDAO;

public class TokenLogic {
	public String execute(AuthCodes authCodes) {
        TokenDAO dao = new TokenDAO();
        return dao.findAuthCodeByClientIdVulnerable(authCodes.getClientId());
    }
}
