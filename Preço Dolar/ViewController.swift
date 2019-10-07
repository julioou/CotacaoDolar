//
//  ViewController.swift
//  Preço Dolar
//
//  Created by Treinamento on 10/4/19.
//  Copyright © 2019 JCAS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var valorDolarLabel: UILabel!
    @IBOutlet var botaoOutletAtualizarValor: UIButton!
    
    let url = URL(string: "https://economia.awesomeapi.com.br/all/USD-BRL")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func botaoAtualizarValor(_ sender: Any) {
        consumindoDados(url: url!)
        
//        let num = formatoUSA(numero: "1513,12")
//        print(num)
    }
    
    
    func consumindoDados(url: URL) {
        self.botaoOutletAtualizarValor.setTitle("Atualizando...", for: .normal)
        let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
            if erro == nil {
                if let dadosRecolhidos = dados {
                    do {
                        if let objetoJson = try JSONSerialization.jsonObject(with: dadosRecolhidos, options: []) as? [String: Any] {
                            if let brl = objetoJson["USD"] as? [String: Any] {
                                if let cotacao = brl["ask"] as? String {
                                    let nsnumber = self.formatoUSA(numero: cotacao)
                                    print(nsnumber)
                                    //Resolvendo a disputa por threads.
                                    DispatchQueue.main.async {
                                        self.botaoOutletAtualizarValor.setTitle("Atualizar Valor", for: .normal)
                                        self.valorDolarLabel.text = self.formatoBR(numero: nsnumber)
                                    }
                                }
                                
                            }
                        }
                    }
                    catch {
                        print("Erro ao recolher objeto json.")
                    }
                }
            }
                //If End
            else {
                print("Falha ao obter dados.")
            }
        }
        //Iniciando a tarefa de recolhimento de dados pela URL.
        tarefa.resume()
    }
    
    //MARK: - Formatando os dados
    func formatoUSA(numero: String) -> NSNumber {
        let nf = NumberFormatter()
        nf.decimalSeparator = ","
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "en_US")
        if let resultado = nf.number(from: numero) {
            return resultado
        } else {
            let retorno = NSNumber(value: 0.00)
            return retorno
        }
    }
    func formatoBR(numero: NSNumber) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = Locale(identifier: "pt_BR")
        if let resultado = nf.string(from: numero) {
            return resultado
        }
        return "0,00"
    }
    
}

