//
//  Copyright (c) 2017 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import FirebaseAuthUI
import MaterialComponents.MDCTypography

class MLAuthPickerViewController: FUIAuthPickerViewController {
  let attributes = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)]
  let attributes2 = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)]
  var agreed = false

  lazy var disclaimer: MDCAlertController = {
    let alertController = MDCAlertController(title: nil, message: "Entiendo que esta aplicacion no esta relacionada con MercadoLibre SRL y esta basada unicamente en las APIS publicas de la misma, licencia MIT.")

    let acceptAction = MDCAlertAction(title: "Estoy de acuerdo!") { action in
      self.agreed = true
    }
    alertController.addAction(acceptAction)
    let termsAction = MDCAlertAction(title: "Terminos") { action in
      UIApplication.shared.open(URL(string: "https://opensource.org/licenses/MIT")!,
                                options: [:], completionHandler: { completion in
        self.present(alertController, animated: true, completion: nil)
      })
    }
    alertController.addAction(termsAction)
    return alertController
  }()

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !agreed {
      self.present(disclaimer, animated: true, completion: nil)
    }
  }
}
