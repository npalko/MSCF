%{
Send email by SMTP using Google.

Typical Usage:
    m = mail();
    m.to = 'someuser@aol.com';
    m.subject = 'hi!';
    m.send();
%}
classdef mail < handle
    properties
        to
        subject
        message
    end
    properties
        DEFAULT_IDENTITY_FILE = '../../.email'
        X_MAILER = ['MATLAB ' version]
    end
    properties
        from
        password
        user
    end
    methods
        function this = mail(varargin)
            
            % 0: use default file
            % 1: use specified file
            % 2: use from, password
            
            
            switch nargin
                case 0
                    this.setIdentityFromFile(this.DEFAULT_IDENTITY_FILE);
                case 1
                    this.setIdentityFromFile(varargin{1});
                case 2
                    this.from = varargin{1};
                    this.password = varargin{2};
                otherwise
                    error('incorrect number of arguments');
            end
            
            this.createMessage();
            this.setFrom();
        end
        function send(this)
            Transport.send(this.message);
        end       
    end
    methods
        function set.to(this, to)
            
        end
        function set.subject(this, subject)
            
        end
        function set.body(this, body)
            
        end
    end
    methods
        function setIdentityFromFile(this, filename)

            f = fopen(filename);
            tmp = textscan(f,'%s',2);
            fclose(f);

            this.from = tmp{1}{1};
            this.password = tmp{1}{2};
                
                

        end
        function setFrom(this)
            msg.setFrom(getInternetAddress(from));
        end
        function createMessage(this)
            

        end
    end
    
end