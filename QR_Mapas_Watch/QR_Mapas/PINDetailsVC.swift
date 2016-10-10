//
//  PINDetailsVC.swift
//  QR_Mapas
//
//  Created by Eliseo Fuentes on 10/9/16.
//  Copyright © 2016 Eliseo Fuentes. All rights reserved.
//

import UIKit
import MapKit
class PINDetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var coordinates: UILabel!
    @IBOutlet weak var photo: UIImageView!
    let imagePicker = UIImagePickerController()
    var customPin = CustomPointAnnotation()
    var sourceViewController = MapsVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        sourceViewController = sender as! MapsVC
        print("On details for PIN")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func getCameraFromRoll(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func getImageFromCamera(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photo.contentMode = .ScaleAspectFit
            photo.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func insertPin(sender: AnyObject) {
        if(name!.text != ""){
            customPin.title = name!.text
            customPin.photo = photo
            sourceViewController.annotation = customPin
            sourceViewController.mapa.addAnnotation(customPin)
            var annotations = sourceViewController.mapa.annotations
            if(annotations.count > 1){
                var i = 0
                var j = 1
                var origen:MKMapItem
                var destino:MKMapItem
                for _ in 1..<sourceViewController.mapa.annotations.count{
                    origen = MKMapItem(placemark: MKPlacemark(coordinate: annotations[i].coordinate, addressDictionary: nil))
                    destino = MKMapItem(placemark: MKPlacemark(coordinate: annotations[j].coordinate, addressDictionary: nil))
                    sourceViewController.obtenerRuta(origen, destino: destino)
                    i+=1
                    j+=1
                }
            }
            navigationController?.popViewControllerAnimated(true)
        }
    }

    @IBAction func cancel(sender: AnyObject) {
        //dismissViewControllerAnimated(true, completion: nil)
        navigationController?.popViewControllerAnimated(true)
        //self.navigationController?.popViewControllerAnimated(true)
    }
}
