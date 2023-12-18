FROM public.ecr.aws/lambda/nodejs:12
RUN pwd
COPY app.js package*.json ./
RUN npm install
RUN npm install --save mysql2
RUN npm install --save mysql
CMD [ "app.lambdaHandler" ]
