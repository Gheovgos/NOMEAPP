package GUI;

import javax.swing.JFrame;
import controller.Controller;
import javax.swing.JTextField;
import javax.swing.JPasswordField;
import javax.swing.JTextPane;
import javax.swing.KeyStroke;

import java.awt.Color;
import java.awt.Font;
import javax.swing.JButton;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.AbstractAction;
import javax.swing.ActionMap;
import javax.swing.ImageIcon;
import javax.swing.InputMap;
import javax.swing.JLabel;

import java.awt.event.ActionEvent;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.SystemColor;
import java.awt.Toolkit;

public class Accesso {

	JFrame frmManabi;
	private Controller controller;
	private JTextField textField;
	private JPasswordField passwordField;
	private JTextPane txtpnPassword;

	public Accesso(Controller c) {
		controller = c;
		initialize();
		frmManabi.setVisible(true);
	}

	private void initialize() {
		frmManabi = new JFrame();
		frmManabi.setTitle("Manabi");
		frmManabi.setIconImage(Toolkit.getDefaultToolkit().getImage(Accesso.class.getResource("/Immagini/icona manabi.png")));
		frmManabi.setResizable(false);
		frmManabi.getContentPane().setFont(new Font("Tahoma", Font.BOLD, 10));
		frmManabi.getContentPane().setEnabled(false);
		frmManabi.getContentPane().setBackground(Color.WHITE);
		frmManabi.setBounds(100, 100,648 ,600);
		frmManabi.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frmManabi.getContentPane().setLayout(null);
		
		textField = new JTextField();
		textField.setBounds(259, 290, 222, 19);
		frmManabi.getContentPane().add(textField);
		textField.setColumns(10);
		
		

	
		
		passwordField = new JPasswordField();
		int condition = JPasswordField.WHEN_FOCUSED;
		  InputMap iMap = passwordField.getInputMap(condition);
		  ActionMap aMap = passwordField.getActionMap();
		  String enter = "enter";
		  iMap.put(KeyStroke.getKeyStroke(KeyEvent.VK_ENTER, 0), enter);
		  aMap.put(enter, new AbstractAction() {

			     public void actionPerformed(ActionEvent arg0) {
			    	 controller.login(textField.getText(), passwordField.getText()); 
						
						if(controller.i != null) {
							MenuInsegnante next = new MenuInsegnante(controller);
							frmManabi.setVisible(false);
							next.frame.setVisible(true); }
						if(controller.s != null) {
							MenuStudente next = new MenuStudente(controller);
							frmManabi.setVisible(false);
							next.frmManabi.setVisible(true);
						}
						else {
							
							JTextPane textError = new JTextPane();
							textError.setVisible(true);
							textError.setFont(new Font("Tahoma", Font.PLAIN, 11));
							textError.setForeground(Color.RED);
							textError.setBackground(Color.WHITE);
							textError.setText("Username o password errati.");
							textError.setEditable(false);
							textError.setBounds(491, 286, 133, 52);
							frmManabi.getContentPane().add(textError);
							
						}
			        
			     }
			  });
		passwordField.setBounds(259, 319, 222, 19);
		frmManabi.getContentPane().add(passwordField);
		
		
		JTextPane txtpnUsername = new JTextPane();
		txtpnUsername.setOpaque(false);
		txtpnUsername.setFont(new Font("Dubai", Font.BOLD, 13));
		txtpnUsername.setEditable(false);
		txtpnUsername.setText("USERNAME");
		txtpnUsername.setBounds(168, 286, 95, 29);
		frmManabi.getContentPane().add(txtpnUsername);
		
		txtpnPassword = new JTextPane();
		txtpnPassword.setOpaque(false);
		txtpnPassword.setText("PASSWORD");
		txtpnPassword.setFont(new Font("Dubai", Font.BOLD, 13));
		txtpnPassword.setEditable(false);
		txtpnPassword.setBounds(168, 315, 95, 29);
		frmManabi.getContentPane().add(txtpnPassword);
		
		JButton btnNewButton = new JButton("ACCEDI");
		btnNewButton.setBackground(new Color(100, 149, 237));
		btnNewButton.setBorderPainted(false);
		btnNewButton.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				
				controller.login(textField.getText(), passwordField.getText()); 
				
				if(controller.i != null) {
					MenuInsegnante next = new MenuInsegnante(controller);
					frmManabi.setVisible(false);
					next.frame.setVisible(true); }
				if(controller.s != null) {
					MenuStudente next = new MenuStudente(controller);
					frmManabi.setVisible(false);
					next.frmManabi.setVisible(true);
				}
				else {
					
					JTextPane textError = new JTextPane();
					textError.setVisible(true);
					textError.setFont(new Font("Tahoma", Font.PLAIN, 11));
					textError.setForeground(Color.RED);
					textError.setBackground(Color.WHITE);
					textError.setText("Username o password errati.");
					textError.setEditable(false);
					textError.setBounds(491, 286, 133, 52);
					frmManabi.getContentPane().add(textError);
					
				}
				
				
			}
		});
		btnNewButton.setFont(new Font("Dialog", Font.BOLD, 9));
		btnNewButton.setBounds(199, 358, 85, 21);
		frmManabi.getContentPane().add(btnNewButton);
		
		JButton btnIscriviti = new JButton("ISCRIVITI");
		btnIscriviti.setBackground(new Color(100, 149, 237));
		btnIscriviti.setBorderPainted(false);
		btnIscriviti.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				TipoAccount tipoAccount = new TipoAccount(controller);
				frmManabi.setVisible(false);
				tipoAccount.setVisible(true);
			}
		});
		btnIscriviti.setFont(new Font("Dialog", Font.BOLD, 9));
		btnIscriviti.setBounds(372, 358, 85, 21);
		frmManabi.getContentPane().add(btnIscriviti);
		
		JLabel Settings = new JLabel("");
		Settings.setToolTipText("Apri impostazioni DB");
		Settings.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				DBSettings next = new DBSettings(controller);
				frmManabi.setVisible(false);
				next.frame.setVisible(true);
				
			}
		});
		Settings.setIcon(new ImageIcon(Accesso.class.getResource("/Immagini/settings.png")));
		Settings.setBounds(596, 0, 36, 29);
		frmManabi.getContentPane().add(Settings);
		
		JLabel lblNewLabel = new JLabel("");
		lblNewLabel.setIcon(new ImageIcon(Accesso.class.getResource("/Immagini/manabi classic blu.png")));
		lblNewLabel.setBounds(244, 150, 258, 138);
		frmManabi.getContentPane().add(lblNewLabel);
		
		JLabel lblNewLabel_1 = new JLabel("");
		lblNewLabel_1.setIcon(new ImageIcon(Accesso.class.getResource("/Immagini/ueueu.png")));
		lblNewLabel_1.setBounds(-592, -37, 1510, 653);
		frmManabi.getContentPane().add(lblNewLabel_1);
		
	}

	public void setVisible(boolean b) {
		// TODO Auto-generated method stub
		
	}
}
