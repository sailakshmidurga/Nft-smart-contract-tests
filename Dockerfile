FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --silent

COPY . .

RUN npx hardhat compile

CMD ["npx", "hardhat", "test", "--no-compile"]
