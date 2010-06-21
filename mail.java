class mail
{
    // public static void send(String host, String from, String pass, String[] to)
    public static void mail()
    
    String host = "smtp.gmail.com";
    String from = "username";
    String pass = "password";
    String[] to = {"nicholas.palko@gmail.com"};
    
    
    Properties props = System.getProperties();
    props.put("mail.smtp.starttls.enable", "true");
    props.put("mail.smtp.host", host);
    props.put("mail.smtp.user", from);
    props.put("mail.smtp.password", pass);
    props.put("mail.smtp.port", "587");
    props.put("mail.smtp.auth", "true");

    Session session = Session.getDefaultInstance(props, null);
    MimeMessage message = new MimeMessage(session);
    message.setFrom(new InternetAddress(from));

    InternetAddress[] toAddress = new InternetAddress[to.length];
    for( int i=0; i < to.length; i++ ) {
        toAddress[i] = new InternetAddress(to[i]);
    }
    System.out.println(Message.RecipientType.TO);

    for( int i=0; i < toAddress.length; i++) {
        message.addRecipient(Message.RecipientType.TO, toAddress[i]);
    }
    message.setSubject("sending in a group");
    message.setText("Welcome to JavaMail");
    Transport transport = session.getTransport("smtp");
    transport.connect(host, from, pass);
    transport.sendMessage(message, message.getAllRecipients());
    transport.close();
    
}