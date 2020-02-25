package com.son.bbs.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.son.bbs.helper.DownloadHelper;
import com.son.bbs.helper.WebHelper;

@Controller
public class ViewController {

	@Autowired
	WebHelper webHelper;
	@Autowired
	DownloadHelper downloadHelper;

	@RequestMapping(value = { "/", "list" })
	public ModelAndView index(Model model) {

		return new ModelAndView("list");
	}

}
