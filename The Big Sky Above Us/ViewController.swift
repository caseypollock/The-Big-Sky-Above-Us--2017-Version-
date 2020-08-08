//
//  ViewController.swift
//  The Big Sky Above Us
//
//  Created by Casey on 09/30/17.
//  Copyright © 2017 Near Future Marketing. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    var sunsHalo = SCNNode(geometry: SCNPlane(width: 0.52, height: 0.52))
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else {return}
        sunsHalo.eulerAngles = pointOfView.eulerAngles
    }
    
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var infoBlur: UIVisualEffectView!
    @IBOutlet weak var infoBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var planetNameButton: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    
    let configuration = ARWorldTrackingConfiguration()
    var soundPlayer = AVPlayer()
    var omniNode = SCNNode()
    let omniGravityNode = SCNNode()
    var lastNodeTouched = [SCNNode]()
    var editingPhoto = false
    var lastNodeName = "The Sun"
    let solarSystemArray = ["The Sun","The Planet Mercury","The Planet Venus","The Planet Earth","The Planet Mars","The Planet Jupiter","The Planet Saturn","The Planet Uranus","The Planet Neptune","Pluto's Still A Planet In My Heart"]
    
    let musicalSelections = ["The Sun":"The Sun","Mercury":"The Planet Mercury","Venus":"The Planet Venus","Earth":"The Planet Earth","Moon":"Luna the Moon","Mars":"The Planet Mars","Deimos":"Deimos the Moon","Phobos":"Phobos the Moon","Jupiter":"The Planet Jupiter","Io":"Io the Moon","Europa":"Europa the Moon","Callisto":"Callisto the Moon","Ganymede":"Ganymede the Moon","Saturn":"The Planet Saturn","Titan":"Titan the Moon","Iapetus":"Iapetus the Moon","Enceladus":"Enceladus the Moon","Mimas":"Mimas the Moon","Neptune":"The Planet Neptune","Triton":"Triton the Moon","Uranus":"The Planet Uranus","Titania":"Titania the Moon","Miranda":"Miranda the Moon","Oberon":"Oberon the Moon","Umbriel":"Umbriel the Moon","Ariel":"Ariel the Moon","Pluto":"Pluto's Still A Planet In My Heart","Charon":"Charon the Moon"]
    
    let celestialDescriptions = ["The Sun":"The Sun is the star at the center of the Solar System. It is a nearly perfect sphere of hot plasma, with internal convective motion that generates a magnetic field via a dynamo process. It is by far the most important source of energy for life on Earth. Its diameter is about 1.39 million kilometers, i.e. 109 times that of Earth, and its mass is about 330,000 times that of Earth, accounting for about 99.86% of the total mass of the Solar System. About three quarters of the Sun's mass consists of hydrogen (~73%); the rest is mostly helium (~25%), with much smaller quantities of heavier elements, including oxygen, carbon, neon, and iron.","Mercury":"Mercury is the smallest and innermost planet in the Solar System. Its orbital period around the Sun of 88 days is the shortest of all the planets in the Solar System. It is named after the Roman deity Mercury, the messenger to the gods.","Venus":"Venus is the second planet from the Sun, orbiting it every 224.7 Earth days. It has the longest rotation period (243 days) of any planet in the Solar System and rotates in the opposite direction to most other planets. It has no natural satellites. It is named after the Roman goddess of love and beauty. It is the second-brightest natural object in the night sky after the Moon, reaching an apparent magnitude of −4.6 – bright enough to cast shadows at night and, rarely, visible to the naked eye in broad daylight. Orbiting within Earth's orbit, Venus is an inferior planet and never appears to venture far from the Sun; its maximum angular distance from the Sun (elongation) is 47.8°.","Earth":"Earth is the third planet from the Sun and the only object in the Universe known to harbor life. According to radiometric dating and other sources of evidence, Earth formed over 4 billion years ago. Earth's gravity interacts with other objects in space, especially the Sun and the Moon, Earth's only natural satellite. Earth revolves around the Sun in 365.26 days, a period known as an Earth year. During this time, Earth rotates about its axis about 366.26 times.","Moon":"The Moon is an astronomical body that orbits planet Earth, being Earth's only permanent natural satellite. It is the fifth-largest natural satellite in the Solar System, and the largest among planetary satellites relative to the size of the planet that it orbits (its primary). Following Jupiter's satellite Io, the Moon is second-densest satellite among those whose densities are known.","Mars":"Located at a varying distance no closer than 33 million miles from the earth, Mars is the fourth planet from the Sun and the second-smallest planet in the Solar System after Mercury. In English Mars carries a name of the Roman god of war, and is often referred to as the Red Planet because the reddish iron oxide prevalent on its surface gives it a reddish appearance that is distinctive among the astronomical bodies visible to the naked eye. Mars is a terrestrial planet with a thin atmosphere, having surface features reminiscent both of the impact craters of the Moon and the valleys, deserts, and polar ice caps of Earth.","Deimos":"Deimos is the smaller and outer of the two natural satellites of the planet Mars, the other being Phobos. Deimos has a mean radius of 6.2 km (3.9 mi) and takes 30.3 hours to orbit Mars. In Greek mythology, Deimos is the twin brother of Phobos and personified terror.","Phobos":"Phobos is the innermost and larger of the two natural satellites of Mars, the other being Deimos. Both moons were discovered in 1877 by American astronomer Asaph Hall. Phobos is a small, irregularly shaped object with a mean radius of 11 km (7 mi), and is seven times as massive as the outer moon, Deimos. Phobos is named after the Greek god Phobos, a son of Ares (Mars) and Aphrodite (Venus), and the personification of horror.","Jupiter":"Jupiter is the fifth planet from the Sun and the largest in the Solar System. It is a giant planet with a mass one-thousandth that of the Sun, but two and a half times that of all the other planets in the Solar System combined. Jupiter and Saturn are gas giants; the other two giant planets, Uranus and Neptune are ice giants. Jupiter has been known to astronomers since antiquity. The Romans named it after their god Jupiter. When viewed from Earth, Jupiter can reach an apparent magnitude of −2.94, bright enough for its reflected light to cast shadows, and making it on average the third-brightest object in the night sky after the Moon and Venus.","Io":"Io is the innermost of the four Galilean moons of the planet Jupiter. It is the fourth-largest moon, has the highest density of all the moons, and has the least amount of water of any known astronomical object in the Solar System. It was discovered in 1610 and was named after the mythological character Io, a priestess of Hera who became one of Zeus's lovers.","Europa":"Europa is the smallest of the four Galilean moons orbiting Jupiter, and the sixth-closest to the planet. It is also the sixth-largest moon in the Solar System. Europa was discovered in 1610 by Galileo Galilei and was named after Europa, the legendary mother of King Minos of Crete and lover of Zeus (the Greek equivalent of the Roman god Jupiter).","Ganymede":"Ganymede is the largest and most massive moon of Jupiter and in the Solar System. The ninth largest object in the Solar System, it is the largest without a substantial atmosphere. It has a diameter of 5,268 km (3,273 mi) and is 8% larger than the planet Mercury, although only 45% as massive. Possessing a metallic core, it has the lowest moment of inertia factor of any solid body in the Solar System and is the only moon known to have a magnetic field. It is the third of the Galilean moons, the first group of objects discovered orbiting another planet, and the seventh satellite outward from Jupiter. Ganymede orbits Jupiter in roughly seven days and is in a 1:2:4 orbital resonance with the moons Europa and Io, respectively.","Callisto":"Callisto is the second-largest moon of Jupiter, after Ganymede. It is the third-largest moon in the Solar System after Ganymede and Saturn's largest moon Titan, and the largest object in the Solar System not to be properly differentiated. Callisto was discovered in 1610 by Galileo Galilei. At 4821 km in diameter, Callisto has about 99% the diameter of the planet Mercury but only about a third of its mass. It is the fourth Galilean moon of Jupiter by distance, with an orbital radius of about 1883000 km.","Neptune":"Neptune is the eighth and farthest known planet from the Sun in the Solar System. In the Solar System, it is the fourth-largest planet by diameter, the third-most-massive planet, and the densest giant planet. Neptune is 17 times the mass of Earth and is slightly more massive than its near-twin Uranus, which is 15 times the mass of Earth and slightly larger than Neptune. Neptune orbits the Sun once every 164.8 years at an average distance of 30.1 astronomical units (4.50×109 km). It is named after the Roman god of the sea and has the astronomical symbol ♆, a stylised version of the god Neptune's trident.","Triton":"Triton is the largest natural satellite of the planet Neptune, and the first Neptunian moon to be discovered. It was discovered on October 10, 1846, by English astronomer William Lassell. It is the only large moon in the Solar System with a retrograde orbit, an orbit in the opposite direction to its planet's rotation. At 2,710 kilometres (1,680 mi) in diameter, it is the seventh-largest moon in the Solar System. Because of its retrograde orbit and composition similar to Pluto's, Triton is thought to have been a dwarf planet captured from the Kuiper belt. Triton has a surface of mostly frozen nitrogen, a mostly water-ice crust, an icy mantle and a substantial core of rock and metal. The core makes up two-thirds of its total mass. Triton has a mean density of 2.061 g/cm3 and is composed of approximately 15–35% water ice.","Uranus":"Uranus is the seventh planet from the Sun. It has the third-largest planetary radius and fourth-largest planetary mass in the Solar System. Uranus is similar in composition to Neptune, and both have different bulk chemical composition from that of the larger gas giants Jupiter and Saturn. For this reason, scientists often classify Uranus and Neptune as ice giants to distinguish them from the gas giants. Uranus's atmosphere is similar to Jupiter's and Saturn's in its primary composition of hydrogen and helium, but it contains more ices such as water, ammonia, and methane, along with traces of other hydrocarbons. It is the coldest planetary atmosphere in the Solar System, with a minimum temperature of 49 K (−224 °C; −371 °F), and has a complex, layered cloud structure with water thought to make up the lowest clouds and methane the uppermost layer of clouds. The interior of Uranus is mainly composed of ices and rock.","Titania":"Titania is the largest of the moons of Uranus and the eighth largest moon in the Solar System at a diameter of 1,578 kilometres (981 mi). Discovered by William Herschel in 1787, Titania is named after the queen of the fairies in Shakespeare's A Midsummer Night's Dream. Its orbit lies inside Uranus's magnetosphere.","Oberon":"Oberon is the outermost major moon of the planet Uranus. It is the second-largest and second most massive of the Uranian moons, and the ninth most massive moon in the Solar System. Discovered by William Herschel in 1787, Oberon is named after the mythical king of the fairies who appears as a character in Shakespeare's A Midsummer Night's Dream. Its orbit lies partially outside Uranus's magnetosphere.","Miranda":"Miranda is the smallest and innermost of Uranus's five round satellites. It was discovered by Gerard Kuiper on 16 February 1948 at McDonald Observatory, and named after Miranda from William Shakespeare's play The Tempest. Like the other large moons of Uranus, Miranda orbits close to its planet's equatorial plane. Because Uranus orbits the Sun on its side, Miranda's orbit is perpendicular to the ecliptic and shares Uranus's extreme seasonal cycle.","Ariel":"Ariel is the fourth-largest of the 27 known moons of Uranus. Ariel orbits and rotates in the equatorial plane of Uranus, which is almost perpendicular to the orbit of Uranus and so has an extreme seasonal cycle. It was discovered in October 1851 by William Lassell and named for a character in two different pieces of literature. As of 2017, much of the detailed knowledge of Ariel derives from a single flyby of Uranus performed by the spacecraft Voyager 2 in 1986, which managed to image around 35% of the moon's surface.","Umbriel":"Umbriel is a moon of Uranus discovered on October 24, 1851, by William Lassell. It was discovered at the same time as Ariel and named after a character in Alexander Pope's poem The Rape of the Lock. Umbriel consists mainly of ice with a substantial fraction of rock, and may be differentiated into a rocky core and an icy mantle. The surface is the darkest among Uranian moons, and appears to have been shaped primarily by impacts. However, the presence of canyons suggests early endogenic processes, and the moon may have undergone an early endogenically driven resurfacing event that obliterated its older surface.","Saturn":"Saturn is the sixth planet from the Sun and the second-largest in the Solar System, after Jupiter. It is a gas giant with an average radius about nine times that of Earth. Although it has only one-eighth the average density of Earth, with its larger volume Saturn is just over 95 times more massive. Saturn is named after the Roman god of agriculture; its astronomical symbol (♄) represents the god's sickle.","Titan":"Titan is the largest moon of Saturn. It is the only moon known to have a dense atmosphere, and the only object in space other than Earth where clear evidence of stable bodies of surface liquid has been found. Titan is the sixth ellipsoidal moon from Saturn. Frequently described as a planet-like moon, Titan is 50% larger than Earth's Moon, and it is 80% more massive. It is the second-largest moon in the Solar System, after Jupiter's moon Ganymede, and is larger than the smallest planet, Mercury, but only 40% as massive.","Mimas":"Mimas is a moon of Saturn which was discovered in 1789 by William Herschel. It is named after Mimas, a son of Gaia in Greek mythology, and is also designated Saturn I. With a diameter of 396 kilometres (246 mi) it is the smallest astronomical body that is known to be rounded in shape because of self-gravitation.","Iapetus":"Iapetus is the third-largest natural satellite of Saturn, eleventh-largest in the Solar System, and the largest body in the Solar System known not to be in hydrostatic equilibrium. Iapetus is best known for its dramatic two-tone coloration. Discoveries by the Cassini mission in 2007 revealed several other unusual features, such as a massive equatorial ridge running three-quarters of the way around the moon.","Enceladus":"Enceladus is the sixth-largest moon of Saturn. It is about 500 kilometers (310 mi) in diameter, about a tenth of that of Saturn's largest moon, Titan. Enceladus is mostly covered by fresh, clean ice, making it one of the most reflective bodies of the Solar System. Consequently, its surface temperature at noon only reaches −198 °C (−324 °F), far colder than a light-absorbing body would be. Despite its small size, Enceladus has a wide range of surface features, ranging from old, heavily cratered regions to young, tectonically deformed terrains that formed as recently as 100 million years ago.","Pluto":"Pluto is a dwarf planet in the Kuiper belt, a ring of bodies beyond Neptune. It was the first Kuiper belt object to be discovered. Pluto was discovered by Clyde Tombaugh in 1930 and was originally considered to be the ninth planet from the Sun. After 1992, its status as a planet was questioned following the discovery of several objects of similar size in the Kuiper belt. In 2005, Eris, a dwarf planet in the scattered disc which is 27% more massive than Pluto, was discovered. This led the International Astronomical Union (IAU) to define the term planet formally in 2006, during their 26th General Assembly. That definition excluded Pluto and reclassified it as a dwarf planet.","Charon":"Charon is the largest of the five known natural satellites of the dwarf planet Pluto. It was discovered in 1978 at the United States Naval Observatory in Washington, D.C., using photographic plates taken at the United States Naval Observatory Flagstaff Station (NOFS). With half the diameter and one eighth the mass of Pluto, it is a very large moon in comparison to its parent body. Its gravitational influence is such that the barycenter of the Pluto–Charon system lies outside Pluto.","Planet X":""]
    var selectedObjectNumber = 0
    var currentTouchPressure = 0.0
    var solarSystemArranged = false
    var userInterfaceHidden = false
    
    
    func registerGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let pinchLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(pinchLocation)
        
        if !hitTest.isEmpty {
            let results = hitTest.first!
            let node = results.node
            //            print(node.name)
            let pinchAction = SCNAction.scale(by: sender.scale, duration: 0)
            let moveAction = SCNAction.move(by: SCNVector3(sender.scale/1000,0,0), duration: 0)
            //            print(sender.scale)
            node.runAction(pinchAction)
            //            omniNode.name = "Sun"
            
            //            if node.name == "Sun" {
            //                node.runAction(pinchAction)
            //                //completes the pinch to scale action for the node tapped.
            //            }
            
            if node.name == "The Sun" {
                node.runAction(pinchAction)
            }
            
            omniGravityNode.enumerateChildNodes { (nodesToMove, stop) -> Void in
                if nodesToMove.name == "orbitalPositionNode" {
                    //                nodesToMove.runAction(moveAction)
                    nodesToMove.removeAllAnimations()
                    nodesToMove.removeAllActions()
                    nodesToMove.position.x = Float(sender.scale/1000)
                    print("Moved all children nodes")
                    sender.scale = 1.0
                }}
            
            omniGravityNode.enumerateChildNodes { (planetNode, stop) -> Void in
                planetNode.runAction(pinchAction)
                print("Scaled all child nodes")
                sender.scale = 1.0
            }}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        self.registerGestureRecognizers()
        hideCameraButton()
        solarSystemArranged = false
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.session.run(configuration)
        self.omniGravityNode.position = SCNVector3(0,0,-0.5)
        self.omniGravityNode.addChildNode(omniNode)
        self.sceneView.scene.rootNode.addChildNode(omniGravityNode)
//        self.omniGravityNode.addChildNode(sunsBetaHalo)
        self.omniGravityNode.addChildNode(sunsHalo)
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 250)
        let forever = SCNAction.repeatForever(action)
        omniNode.runAction(forever)
        
        self.descriptionView.indicatorStyle = .white
        infoBlur.layer.cornerRadius = 25

        musicPicker(selectedObjectNumber: selectedObjectNumber)
        let theSun = viewSun()
        theSun.planetNode.name = "The Sun"
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTapped = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTapped)
        let hitTest = sceneViewTapped.hitTest(touchCoordinates)
        if hitTest.isEmpty {
//            print("Didn't touch anything")
            if userInterfaceHidden == false {
            hideUserInterface()
            } else if userInterfaceHidden == true {
            showUserInterface()
            }
        } else {
            let results = hitTest.first!
            if results.node.name != nil {
            lastNodeTouched.removeAll()
            lastNodeTouched.append(results.node)
            let selectionName = results.node.name!
            self.planetNameButton.setTitle(selectionName, for: .normal)
            self.descriptionView.text = celestialDescriptions[selectionName]
            let songSelected = musicalSelections[selectionName]
            self.alternateMusicPicker(selectedSongName: songSelected!)
            lastNodeName = selectionName
            showUserInterface()
            }
            
        }
        }
    
    class Planet {
        // Used to represent Stars, Moons, and Planets.
        var name : String! //The displayed name of the planet.
        var description : String! //A brief description of the planet.
        var diffuse : UIImage? //The diffuse material.
        var specular : UIImage? //The specular material.
        var emission : UIImage? //The emission material.
        var normal : UIImage? //The normal material.
        var surfaceTemperature : Float! //Currently written in fahrenheit.
        var isMoon : Bool! //Determines if the planet node should be attached to another planet.
        var planetNode = SCNNode() //The node that visualizes the planet.
        var selectionNode = SCNNode()
        var gravitationalFieldNode = SCNNode() //The node that holds any objects orbiting the planet.
        var orbitalPositionNode = SCNNode() //The root node that controls the planets position around the omninode.
        var position : SCNVector3! //The position of the planet when arranged.
        var orbitLength : Double! //Amount of days it takes to orbit the parent star
        var dayLength : Double! //Amount of hours it takes to turn on the planet's axis.
        var mass : Float! //Kilograms, Tons
        var radius : Float! //Miles, Kilometers??
        var rings : [SCNNode]? //A container  for ringed planets.
        var model : SCNScene?
//        func playSong() {
//        }
    }
    
    func planetAssembler(name: String, description: String, diffuse: UIImage?, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3, orbitLength: Double, dayLength: Double, mass: Float, radius: Float, surfaceTemperature: Float, rings: [SCNNode], isMoon: Bool) -> Planet {
        
        let newPlanet = Planet()
        newPlanet.name = name
        newPlanet.planetNode.name = name
        newPlanet.description = description
        newPlanet.gravitationalFieldNode.position = position
        newPlanet.planetNode.geometry = SCNSphere(radius: CGFloat(radius))
        newPlanet.planetNode.geometry?.firstMaterial?.diffuse.contents = diffuse
        newPlanet.planetNode.geometry?.firstMaterial?.specular.contents = specular
        newPlanet.planetNode.geometry?.firstMaterial?.emission.contents = emission
        newPlanet.planetNode.geometry?.firstMaterial?.normal.contents = normal
        newPlanet.orbitLength = orbitLength
        newPlanet.dayLength = dayLength
        newPlanet.surfaceTemperature = surfaceTemperature
        newPlanet.mass = mass
        
        if rings.count == 1 {
            //Maybe we should initialize these here and change the array to an int
            let newRing = rings[0]
            newPlanet.planetNode.addChildNode(newRing)
        } else if rings.count == 2 {
            let newRing = rings[0]
            let secondRing = rings[1]
            newPlanet.planetNode.addChildNode(newRing)
            newPlanet.planetNode.addChildNode(secondRing)
        }
        
        if solarSystemArranged == false && isMoon == false {
            omniNode.geometry = newPlanet.planetNode.geometry
            
            self.hideUserInterface {
                self.planetNameButton.alpha = 1
                self.descriptionView.alpha = 1
                self.mapButton.alpha = 1
                self.resetButton.alpha = 1

                self.descriptionView.text = newPlanet.description
                self.planetNameButton.setTitle(newPlanet.name, for: .normal)
                self.descriptionView.setContentOffset(.init(x: 0.0, y: -2.0), animated: false)
                
//                self.descriptionView.setContentOffset(.zero, animated: false) //Collins Code
                self.showUserInterface()
            }
            
            orbit(planet: newPlanet)
            spin(planet: newPlanet)
        } else if solarSystemArranged == false && isMoon == true{
            orbit(planet: newPlanet)
            arrange(planet: newPlanet, target: omniGravityNode)
            spin(planet: newPlanet)
        } else if solarSystemArranged == true && isMoon == false {
            orbit(planet: newPlanet)
            arrange(planet: newPlanet, target: omniGravityNode)
            spin(planet: newPlanet)
        }
        return newPlanet
    }
    
    func switchPlanet() {
        //Called when the user taps the next and previous buttons in the default view.
        if solarSystemArranged == false {
            switch selectedObjectNumber {
            case 1: omniGravityNode.addChildNode(viewMercury().planetNode)
            case 2: omniGravityNode.addChildNode(viewVenus().planetNode)
            case 3: omniGravityNode.addChildNode(viewEarth().planetNode)
            case 4: omniGravityNode.addChildNode(viewMars().planetNode)
            case 5: omniGravityNode.addChildNode(viewJupiter().planetNode)
            case 6: omniGravityNode.addChildNode(viewSaturn().planetNode)
            case 7: omniGravityNode.addChildNode(viewUranus().planetNode)
            case 8: omniGravityNode.addChildNode(viewNeptune().planetNode)
            case 9: omniGravityNode.addChildNode(viewPluto().planetNode)
            default: omniGravityNode.addChildNode(viewSun().planetNode)
            }}
    }
    
    
    func musicPicker(selectedObjectNumber: Int) {
        do {
            if let selectedCelestialSound = Bundle.main.url(forResource: "\(solarSystemArray[selectedObjectNumber])", withExtension: "mp3") {
                print(selectedCelestialSound.absoluteString)
                self.soundPlayer = try AVPlayer(url: selectedCelestialSound)
                self.soundPlayer.play()
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func alternateMusicPicker(selectedSongName: String) {
        do {
            if let selectedCelestialSound = Bundle.main.url(forResource: selectedSongName, withExtension: "mp3") {
                print(selectedCelestialSound.absoluteString)
                self.soundPlayer = try AVPlayer(url: selectedCelestialSound)
                self.soundPlayer.play()
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
    
    
    @IBAction func resetPressed(_ sender: Any) {
        restartSession()
    }
    
    func restartSession() {
        selectedObjectNumber = 0
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (omniNode, _) in
            omniNode.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sunsHalo = SCNNode(geometry: SCNPlane(width: 0.52, height: 0.52))
        viewDidLoad()
    }
    
    func hideUserInterface(withCompletion completion: (()->Void)? = nil) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.mapButton.alpha = 0
            self.playPauseButton.alpha = 0
            self.descriptionView.alpha = 0
            self.resetButton.alpha = 0
            self.lastButton.alpha = 0
            self.nextButton.alpha = 0
            self.planetNameButton.alpha = 0
            self.userInterfaceHidden = true
            
            self.infoBottomConstraint.constant = -self.infoBlur.frame.height
            self.view.layoutIfNeeded()
        }, completion: { complete in
            if complete {
                completion?()
            }
        })
    }
    
    func showUserInterface(withCompletion completion: (()->Void)? = nil) {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.resetButton.alpha = 1
            self.lastButton.alpha = 1
            self.nextButton.alpha = 1
            self.playPauseButton.alpha = 1
            self.descriptionView.alpha = 1
            self.mapButton.alpha = 1
            self.planetNameButton.alpha = 1
            self.userInterfaceHidden = false
            self.hideCameraButton()
            self.infoBottomConstraint.constant = 16
            self.view.layoutIfNeeded()

        }, completion: { complete in
            if complete {
                completion?()
            }
        })
        
        UIView.animate(withDuration: 0.25) {
        }
    }
    
    
    @IBAction func cameraPressed(_ sender: Any) {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        cameraButton.isHidden = true
        cameraButton.isEnabled = false
        editingPhoto = true
        let snapshot = sceneView.snapshot()
        photoView.image = snapshot
        UIImageWriteToSavedPhotosAlbum(snapshot, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(dismissPhotoEditor), userInfo: nil, repeats: false)
    }
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    @objc func dismissPhotoEditor() {
        photoView.image = nil
        showUserInterface()
        hideCameraButton()
    }
    
    @IBAction func downSwipe(_ sender: Any) {
//        displayCameraButton()
        hideUserInterface()
        cameraButton.isHidden = false
        cameraButton.isEnabled = true
    }
    
    func displayCameraButton() {
        self.infoBlur.alpha = 0
    }
    
    @objc func hideCameraButton() {
        cameraButton.isEnabled = false
        cameraButton.isHidden = true
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        if solarSystemArranged == false {
            destroyMoons()
            lastNodeTouched.removeAll()
        }
        let maximumValue = solarSystemArray.count - 1
        let nextSelection = selectedObjectNumber + 1
        
        if nextSelection <= maximumValue {
            selectedObjectNumber += 1
        } else {
            selectedObjectNumber = 0
        }
        musicPicker(selectedObjectNumber: selectedObjectNumber)
        switchPlanet()
    }
    @IBAction func rightSwipe(_ sender: Any) {
        lastPressed(self)
    }
    
    @IBAction func lastPressed(_ sender: Any) {
        if solarSystemArranged == false {
            destroyMoons()
            lastNodeTouched.removeAll()
        }
        let minimumValue = 0
        let previousSelection = selectedObjectNumber - 1
        if previousSelection < minimumValue {
            selectedObjectNumber = solarSystemArray.count - 1
        } else {
            selectedObjectNumber -= 1
        }
        musicPicker(selectedObjectNumber: selectedObjectNumber)
        switchPlanet()
    }
    
    @IBAction func leftSwipe(_ sender: Any) {
        nextPressed(self)
    }
    @IBAction func mapTogglePressed(_ sender: Any) {
        if solarSystemArranged == false {
            destroyMoons()
            arrangeSolarSystem()
        } else if solarSystemArranged ==  true {
            destroyMoons()
            solarSystemArranged = false
            omniGravityNode.addChildNode(omniNode)
            selectedObjectNumber = 0
            viewSun()
        }
    }
    
    
    @IBAction func planetNameTapped(_ sender: Any) {
        if lastNodeTouched.count == 0 {
            self.descriptionView.text = "No celestial bodies are currently selected. Try tapping any planet or moon before pressing this button."
        } else {
        
        let lastNodeUserTouched = lastNodeTouched[0]
        let nameNode = SCNNode(geometry: SCNText(string: lastNodeName, extrusionDepth: 0.02))
//        let highlighterNode = SCNNode(geometry: SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.1))
        lastNodeUserTouched.parent?.addChildNode(nameNode)
        nameNode.position = SCNVector3(0.06,-0.1,0)
            nameNode.scale = SCNVector3(0.007,0.007,0.007)
        }
    }
    
    
    func viewSun() -> Planet {
        //Actual radius 695,700 km
        omniNode.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
        sunsHalo.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Sun Halo Diffuse")
        omniGravityNode.addChildNode(sunsHalo)
        
        let sun = planetAssembler(name: "The Sun", description: "The Sun is the star at the center of the Solar System. It is a nearly perfect sphere of hot plasma, with internal convective motion that generates a magnetic field via a dynamo process. It is by far the most important source of energy for life on Earth. Its diameter is about 1.39 million kilometers, i.e. 109 times that of Earth, and its mass is about 330,000 times that of Earth, accounting for about 99.86% of the total mass of the Solar System. About three quarters of the Sun's mass consists of hydrogen (~73%); the rest is mostly helium (~25%), with much smaller quantities of heavier elements, including oxygen, carbon, neon, and iron.", diffuse: #imageLiteral(resourceName: "Sun Diffuse"), specular: nil, emission: #imageLiteral(resourceName: "Sun Emission"), normal: nil, position: SCNVector3(0,0,0), orbitLength: 1000, dayLength: 250, mass: 0, radius: 0.205, surfaceTemperature: 9941, rings: [], isMoon: false)
        return sun
    }
    
    
    func viewMercury() -> Planet {
        //Actual radius 2,440 km
        let mercury = planetAssembler(name: "Mercury", description: "Mercury is the smallest and innermost planet in the Solar System. Its orbital period around the Sun of 88 days is the shortest of all the planets in the Solar System. It is named after the Roman deity Mercury, the messenger to the gods.", diffuse: #imageLiteral(resourceName: "Mercury Diffuse"), specular: nil, emission: nil, normal: #imageLiteral(resourceName: "Mecury Normal Texture"), position: SCNVector3(0.42,0,0), orbitLength: 8.8, dayLength: 24, mass: 0, radius: 0.02, surfaceTemperature: 800, rings: [], isMoon: false)
        return mercury
    }
    
    func viewVenus() -> Planet {
        //Actual radius 6,052 km
        let venus = planetAssembler(name: "Venus", description: "Venus is the second planet from the Sun, orbiting it every 224.7 Earth days. It has the longest rotation period (243 days) of any planet in the Solar System and rotates in the opposite direction to most other planets. It has no natural satellites. It is named after the Roman goddess of love and beauty. It is the second-brightest natural object in the night sky after the Moon, reaching an apparent magnitude of −4.6 – bright enough to cast shadows at night and, rarely, visible to the naked eye in broad daylight. Orbiting within Earth's orbit, Venus is an inferior planet and never appears to venture far from the Sun; its maximum angular distance from the Sun (elongation) is 47.8°.", diffuse: #imageLiteral(resourceName: "Venus Diffuse"), specular: nil, emission: #imageLiteral(resourceName: "Venus Emission"), normal: nil, position: SCNVector3(0.55,0,0), orbitLength: 22.4, dayLength: 24, mass: 0, radius: 0.042, surfaceTemperature: 864, rings: [], isMoon: false) //0.15
        return venus
    }
    
    func viewEarth() -> Planet {
        // Actual radius 6,371 km
        let earth = planetAssembler(name: "Earth", description: "Earth is the third planet from the Sun and the only object in the Universe known to harbor life. According to radiometric dating and other sources of evidence, Earth formed over 4 billion years ago. Earth's gravity interacts with other objects in space, especially the Sun and the Moon, Earth's only natural satellite. Earth revolves around the Sun in 365.26 days, a period known as an Earth year. During this time, Earth rotates about its axis about 366.26 times.", diffuse: #imageLiteral(resourceName: "Earth Diffuse"), specular: #imageLiteral(resourceName: "Earth Specular"), emission: #imageLiteral(resourceName: "Earth Emisison"), normal: #imageLiteral(resourceName: "Earth Normal"), position: SCNVector3(0.75,0,0), orbitLength: 36.5, dayLength: 24, mass: 0, radius: 0.05, surfaceTemperature: 61, rings: [], isMoon: false)
        if solarSystemArranged == false {
            viewMoon()
        }
        return earth
    }
    
    
    func viewMoon() -> Planet {
        //Actual radius 1,737 km
        let moon = planetAssembler(name: "Moon", description: "", diffuse: #imageLiteral(resourceName: "Moon Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0.08,0,0), orbitLength: 6, dayLength: 24, mass: 0, radius: 0.01, surfaceTemperature: -298, rings: [], isMoon: true)
        return moon
    }
    
    func viewMars() -> Planet {
        //Actual radius 3,390 km

        let mars = planetAssembler(name: "Mars", description: "Located at a varying distance no closer than 33 million miles from the earth, Mars is the fourth planet from the Sun and the second-smallest planet in the Solar System after Mercury. In English Mars carries a name of the Roman god of war, and is often referred to as the Red Planet because the reddish iron oxide prevalent on its surface gives it a reddish appearance that is distinctive among the astronomical bodies visible to the naked eye. Mars is a terrestrial planet with a thin atmosphere, having surface features reminiscent both of the impact craters of the Moon and the valleys, deserts, and polar ice caps of Earth.", diffuse: #imageLiteral(resourceName: "Mars Diffuse"), specular: nil, emission: #imageLiteral(resourceName: "Mars Emission"), normal: #imageLiteral(resourceName: "Mars Normal"), position: SCNVector3(0.94,0,0), orbitLength: 68.7, dayLength: 24, mass: 0, radius: 0.04, surfaceTemperature: 0, rings: [], isMoon: false)
        if solarSystemArranged == false {
            viewPhobos()
            viewDeimos()
        } else if solarSystemArranged == true {

        }

        return mars
    }
    
    
    func viewPhobos() -> Planet {
        //Actual radius 11.1 km
        //        let phobosModel = SCNScene(named: "art.scnassets/phobosByCasey.scn")
        //        let phobosNode = (phobosModel?.rootNode.clone())!
        //        phobos.planetNode.opacity = 0

        let phobos = planetAssembler(name: "Phobos", description: "", diffuse: #imageLiteral(resourceName: "Phobos Diffuse"), specular: nil, emission: nil, normal: #imageLiteral(resourceName: "Mountainy Normal Texture"), position: SCNVector3(0.06,0,0), orbitLength: 6, dayLength: 24, mass: 0, radius: 0.011, surfaceTemperature: 0, rings: [], isMoon: true)
        return phobos
    }
    
    func viewDeimos() -> Planet {
        //Actual radius 6.2 km
        //        let deimosModel = SCNScene(named: "art.scnassets/deimosByCasey.scn")
        //        let deimosNode = (deimosModel?.rootNode.clone())!
        let deimos = planetAssembler(name: "Deimos", description: "", diffuse: #imageLiteral(resourceName: "Deimos Diffuse"), specular: nil, emission: nil, normal: #imageLiteral(resourceName: "Rough Normal Texture"), position: SCNVector3(0.1,0,0), orbitLength: 9, dayLength: 24, mass: 0, radius: 0.006, surfaceTemperature: 0, rings: [], isMoon: true)
        //        deimos.planetNode.opacity = 0
        return deimos
    }
    
    func viewJupiter() -> Planet {
        //Actual radius 69,911 km
        let jupiter = planetAssembler(name: "Jupiter", description: "Jupiter is the fifth planet from the Sun and the largest in the Solar System. It is a giant planet with a mass one-thousandth that of the Sun, but two and a half times that of all the other planets in the Solar System combined. Jupiter and Saturn are gas giants; the other two giant planets, Uranus and Neptune are ice giants. Jupiter has been known to astronomers since antiquity. The Romans named it after their god Jupiter. When viewed from Earth, Jupiter can reach an apparent magnitude of −2.94, bright enough for its reflected light to cast shadows, and making it on average the third-brightest object in the night sky after the Moon and Venus.", diffuse: #imageLiteral(resourceName: "Jupiter Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(1.27,0,0), orbitLength: 36.5 * 12, dayLength: 24, mass: 0, radius: 0.15, surfaceTemperature: 0, rings: [], isMoon: false)
        if solarSystemArranged == false {
            viewIo()
            viewEuropa()
            viewGanymede()
            viewCallisto()
        }
        return jupiter
    }
    
    func viewIo() -> Planet {
        //Actual radius of 1821.3 km
        let io = planetAssembler(name: "Io", description: "", diffuse: #imageLiteral(resourceName: "Io Diffuse"), specular: nil, emission: nil, normal: #imageLiteral(resourceName: "Icy Normal Texture"), position: SCNVector3(-0.17,0,0.2), orbitLength: 15, dayLength: 24, mass: 0, radius: 0.014, surfaceTemperature: 0, rings: [], isMoon: true)
        return io
    }
    
    func viewEuropa() -> Planet {
        //Actual radius of 3,100 km
        let europa = planetAssembler(name: "Europa", description: "", diffuse: #imageLiteral(resourceName: "Europa Diffuse"), specular: nil, emission: nil, normal: #imageLiteral(resourceName: "Icy Normal Texture"), position: SCNVector3(0.172,-0.08,0), orbitLength: 23, dayLength: 33, mass: 0, radius: 0.007, surfaceTemperature: 0, rings: [], isMoon: true)
        return europa
    }
    
    func viewGanymede() -> Planet {
        //Actual radius of 2,631.2 km
        let ganymede = planetAssembler(name: "Ganymede", description: "", diffuse: #imageLiteral(resourceName: "Ganymede Diffuse"), specular: nil, emission: nil, normal: #imageLiteral(resourceName: "Volcanic Normal Texture"), position: SCNVector3(0.19,0.05,0), orbitLength: 9, dayLength: 24, mass: 0, radius: 0.018, surfaceTemperature: 0, rings: [], isMoon: true)
        return ganymede
    }
    
    func viewCallisto() -> Planet {
        //Actual radius of 2410.8 km
        let callisto = planetAssembler(name: "Callisto", description: "", diffuse: #imageLiteral(resourceName: "Callisto Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0.14,0.2,0), orbitLength: 8, dayLength: 24, mass: 0, radius: 0.019, surfaceTemperature: 0, rings: [], isMoon: true)
        return callisto
    }
    
    func viewNeptune() -> Planet {
        //Actual radius of 24,622 km
        let neptune = planetAssembler(name: "Neptune", description: "Neptune is the eighth and farthest known planet from the Sun in the Solar System. In the Solar System, it is the fourth-largest planet by diameter, the third-most-massive planet, and the densest giant planet. Neptune is 17 times the mass of Earth and is slightly more massive than its near-twin Uranus, which is 15 times the mass of Earth and slightly larger than Neptune. Neptune orbits the Sun once every 164.8 years at an average distance of 30.1 astronomical units (4.50×109 km). It is named after the Roman god of the sea and has the astronomical symbol ♆, a stylised version of the god Neptune's trident.", diffuse: #imageLiteral(resourceName: "Neptune Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(1.76,0,0), orbitLength: 36.5 * 170, dayLength: 24, mass: 0, radius: 0.04, surfaceTemperature: 0, rings: [], isMoon: false)
        if solarSystemArranged == false {
            viewTriton()
        }
        return neptune
    }
    
    func viewTriton() -> Planet {
        //Actual radius of 2,700 km
        let triton = planetAssembler(name: "Triton", description: "", diffuse: #imageLiteral(resourceName: "Triton Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0.07,0.04,0), orbitLength: 26, dayLength: 24, mass: 0, radius: 0.009, surfaceTemperature: 0, rings: [], isMoon: true)
        return triton
    }
    
    func viewUranus() -> Planet {
        //Actual radius of 25,362 km
        let uranusRing = SCNNode(geometry: SCNTube(innerRadius: 0.074, outerRadius: 0.075, height: 0.0006))
        uranusRing.opacity = 0.3
        let uranus = planetAssembler(name: "Uranus", description: "Uranus is the seventh planet from the Sun. It has the third-largest planetary radius and fourth-largest planetary mass in the Solar System. Uranus is similar in composition to Neptune, and both have different bulk chemical composition from that of the larger gas giants Jupiter and Saturn. For this reason, scientists often classify Uranus and Neptune as ice giants to distinguish them from the gas giants. Uranus's atmosphere is similar to Jupiter's and Saturn's in its primary composition of hydrogen and helium, but it contains more ices such as water, ammonia, and methane, along with traces of other hydrocarbons. It is the coldest planetary atmosphere in the Solar System, with a minimum temperature of 49 K (−224 °C; −371 °F), and has a complex, layered cloud structure with water thought to make up the lowest clouds and methane the uppermost layer of clouds. The interior of Uranus is mainly composed of ices and rock.", diffuse: #imageLiteral(resourceName: "Uranus Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(1.55,0,0), orbitLength: 36.5 * 84, dayLength: 24, mass: 0, radius: 0.06, surfaceTemperature: -357, rings: [uranusRing], isMoon: false)
        uranus.planetNode.eulerAngles = SCNVector3(Float(360.degreesToRadians),0,0)
        if solarSystemArranged == false {
            viewTitania()
            viewMiranda()
            viewOberon()
            viewUmbriel()
            viewAriel()
        }
        return uranus
    }
    
    func viewTitania() -> Planet {
        //Actual radius of 788.9 km
        let titania = planetAssembler(name: "Titania", description: "", diffuse: #imageLiteral(resourceName: "Titania Diffuse"), specular: nil, emission: nil, normal: #imageLiteral(resourceName: "Mountainy Normal Texture"), position: SCNVector3(0.133,0,0), orbitLength: 26, dayLength: 24, mass: 0, radius: 0.0138, surfaceTemperature: 0, rings: [], isMoon: true)
        return titania
    }
    
    func viewMiranda() -> Planet {
        //Actual radius of ‎235.8 km
        let miranda = planetAssembler(name: "Miranda", description: "", diffuse: #imageLiteral(resourceName: "Miranda DIffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0.09,0,0), orbitLength: 18, dayLength: 24, mass: 0, radius: 0.0082, surfaceTemperature: 0, rings: [], isMoon: true)
        return miranda
    }
    
    func viewOberon() -> Planet {
        //Actual radius of ‎761.4 km
        let oberon = planetAssembler(name: "Oberon", description: "", diffuse: #imageLiteral(resourceName: "Oberon Diffuse"), specular: nil, emission: nil, normal: #imageLiteral(resourceName: "Rocky Normal Texture"), position: SCNVector3(0.1124,0.001,0), orbitLength: 23, dayLength: 24, mass: 0, radius: 0.008, surfaceTemperature: 0, rings: [], isMoon: true)
        return oberon
    }
    
    func viewUmbriel() -> Planet {
        //Actual radius of 584.7 km
        let umbriel = planetAssembler(name: "Umbriel", description: "", diffuse: #imageLiteral(resourceName: "Umbriel Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0.09,0,0.3), orbitLength: 47, dayLength: 24, mass: 0, radius: 0.012, surfaceTemperature: -324, rings: [], isMoon: true)
        return umbriel
    }
    
    func viewAriel() -> Planet {
        //Actual radius of ‎578.9 km
        let ariel = planetAssembler(name: "Ariel", description: "", diffuse: #imageLiteral(resourceName: "Ariel Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0.04,0.08,0), orbitLength: 26, dayLength: 24, mass: 0, radius: 0.005, surfaceTemperature: -351, rings: [], isMoon: true)
        return ariel
    }
    
    func viewSaturn() -> Planet {
        //Actual radius of 58,232 km
        let saturnsInnerRing = SCNNode(geometry: SCNTube(innerRadius: 0.058, outerRadius: 0.077, height: 0.001))
        let saturnsOuterRing = SCNNode(geometry: SCNTube(innerRadius: 0.081, outerRadius: 0.094, height: 0.001))
        saturnsInnerRing.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Saturns HD Rings")
        saturnsOuterRing.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Saturns HD Rings")

        let saturn = planetAssembler(name: "Saturn", description: "Saturn is the sixth planet from the Sun and the second-largest in the Solar System, after Jupiter. It is a gas giant with an average radius about nine times that of Earth. Although it has only one-eighth the average density of Earth, with its larger volume Saturn is just over 95 times more massive. Saturn is named after the Roman god of agriculture; its astronomical symbol (♄) represents the god's sickle.", diffuse: #imageLiteral(resourceName: "Saturn Diffuse"), specular: nil, emission: #imageLiteral(resourceName: "Saturn Emission"), normal: nil, position: SCNVector3(1.94,0,0), orbitLength: 36.5 * 37, dayLength: 24, mass: 0, radius: 0.05, surfaceTemperature: -288, rings: [saturnsInnerRing,saturnsOuterRing], isMoon: false)
        
        if solarSystemArranged == false {
            viewTitan()
            viewMimas()
            viewIapetus()
            viewEnceladus()
        }
        return saturn
    }
    
    func viewTitan() -> Planet {
        //Actual radius of 2,576 km
        let titan = planetAssembler(name: "Titan", description: "", diffuse: #imageLiteral(resourceName: "Titan Diffuse"), specular: nil, emission: nil, normal: #imageLiteral(resourceName: "Volcanic Normal Texture"), position: SCNVector3(0.2,0.04,0), orbitLength: 18, dayLength: 24, mass: 0, radius: 0.0062, surfaceTemperature: -290, rings: [], isMoon: true)
        return titan
    }
    
    func viewMimas() -> Planet {
        //Actual radius of ? km
        let mimas = planetAssembler(name: "Mimas", description: "", diffuse: #imageLiteral(resourceName: "Mimas Diffuse"), specular: nil, emission: nil, normal: #imageLiteral(resourceName: "Mountainy Normal Texture"), position: SCNVector3(0.2,0.03,0), orbitLength: 24, dayLength: 24, mass: 0, radius: 0.0076, surfaceTemperature: 0, rings: [], isMoon: true)
        return mimas
    }
    
    func viewIapetus() -> Planet {
        //Actual radius of ? km
        let Iapetus = planetAssembler(name: "Iapetus", description: "", diffuse: #imageLiteral(resourceName: "Iapetus Diffuse"), specular: nil, emission: nil, normal: #imageLiteral(resourceName: "Rocky Normal Texture"), position: SCNVector3(0.394,0.005,0), orbitLength: 35, dayLength: 24, mass: 0, radius: 0.0061, surfaceTemperature: 0, rings: [], isMoon: true)
        return Iapetus
    }
    
    func viewEnceladus() -> Planet {
        //Actual radius of ? km
        let enceladus = planetAssembler(name: "Enceladus", description: "", diffuse: #imageLiteral(resourceName: "Enceladus Diffuse"), specular: nil, emission: nil, normal: #imageLiteral(resourceName: "Icy Normal Texture"), position: SCNVector3(0.187,0,0.002), orbitLength: 38, dayLength: 24, mass: 0, radius: 0.0058, surfaceTemperature: 0, rings: [], isMoon: true)
        return enceladus
    }
    
    
    func viewPluto() -> Planet {
        //Actual radius of 1,187 km
        let pluto = planetAssembler(name: "Pluto", description: "Pluto is a dwarf planet in the Kuiper belt, a ring of bodies beyond Neptune. It was the first Kuiper belt object to be discovered. Pluto was discovered by Clyde Tombaugh in 1930 and was originally considered to be the ninth planet from the Sun. After 1992, its status as a planet was questioned following the discovery of several objects of similar size in the Kuiper belt. In 2005, Eris, a dwarf planet in the scattered disc which is 27% more massive than Pluto, was discovered. This led the International Astronomical Union (IAU) to define the term planet formally in 2006, during their 26th General Assembly. That definition excluded Pluto and reclassified it as a dwarf planet.", diffuse: #imageLiteral(resourceName: "Pluto Diffuse"), specular: nil, emission: nil, normal: #imageLiteral(resourceName: "Mountainy Normal Texture"), position: SCNVector3(2.1,0,0), orbitLength: 36.5 * 248, dayLength: 24, mass: 0, radius: 0.007, surfaceTemperature: -400, rings: [], isMoon: false)
        if solarSystemArranged == false {
            viewCharon()
        }
        return pluto
    }
    
    func viewCharon() -> Planet {
        //Actual radius ? km
        let charon = planetAssembler(name: "Charon", description: "", diffuse: #imageLiteral(resourceName: "Charon DIffuse"), specular: nil, emission: nil, normal: #imageLiteral(resourceName: "Rough Normal Texture"), position: SCNVector3(0.015,0,0), orbitLength: 7, dayLength: 24, mass: 0, radius: 0.003, surfaceTemperature: 0, rings: [], isMoon: true)
        return charon
    }
    
//    func viewPlanetX() -> Planet {
//        let planetx = planetAssembler(name: "The Planet X", description: "An undiscovered distant.", diffuse: nil, specular: nil, emission: nil, normal: nil, position: SCNVector3(4,0,0), orbitLength: 36.5 * 365, dayLength: 36, mass: 0, radius: 0.123, surfaceTemperature: -4000, rings: [], isMoon: false)
//        return planetx
//    }
    
    func arrangeSolarSystem() {
        omniGravityNode.position = SCNVector3Make(0, 0, -0.5)
        solarSystemArranged = true
        viewSun().planetNode.name = "The Sun"
        let mercury = viewMercury()
        
        let venus = viewVenus()
       
        let earth = viewEarth()
        let moon = viewMoon()
        arrange(planet: moon, target: earth.gravitationalFieldNode)
        orbit(planet: moon)
        spin(planet: moon)
        
        let mars = viewMars()
        let phobos = viewPhobos()
        arrange(planet: phobos, target: mars.gravitationalFieldNode)
        orbit(planet: phobos)
        spin(planet: phobos)
        let deimos = viewDeimos()
        arrange(planet: deimos, target: mars.gravitationalFieldNode)
        orbit(planet: deimos)
        spin(planet: deimos)
        
        let jupiter = viewJupiter()
        let io = viewIo()
        arrange(planet: io, target: jupiter.gravitationalFieldNode)
        orbit(planet: io)
        spin(planet: io)
        let europa = viewEuropa()
        arrange(planet: europa, target: jupiter.gravitationalFieldNode)
        orbit(planet: europa)
        spin(planet: europa)
        let ganymede = viewGanymede()
        arrange(planet: ganymede, target: jupiter.gravitationalFieldNode)
        orbit(planet: ganymede)
        spin(planet: ganymede)
        let callisto = viewCallisto()
        arrange(planet: callisto, target: jupiter.gravitationalFieldNode)
        orbit(planet: callisto)
        spin(planet: callisto)

        let neptune = viewNeptune()
        let triton = viewTriton()
        arrange(planet: triton, target: neptune.gravitationalFieldNode)
        orbit(planet: triton)
        spin(planet: triton)
        
        let saturn = viewSaturn()
        let titan = viewTitan()
        arrange(planet: titan, target: saturn.gravitationalFieldNode)
        orbit(planet: titan)
        spin(planet: titan)
        let phoebe = viewMimas()
        arrange(planet: phoebe, target: saturn.gravitationalFieldNode)
        orbit(planet: phoebe)
        spin(planet: phoebe)
        let Iapetus = viewIapetus()
        arrange(planet: Iapetus, target: saturn.gravitationalFieldNode)
        orbit(planet: Iapetus)
        spin(planet: Iapetus)
        let enceladus = viewEnceladus()
        arrange(planet: enceladus, target: saturn.gravitationalFieldNode)
        orbit(planet: enceladus)
        spin(planet: enceladus)
       
        let uranus = viewUranus()
        let titania = viewTitania()
        arrange(planet: titania, target: uranus.gravitationalFieldNode)
        orbit(planet: titania)
        spin(planet: titania)
        let miranda = viewMiranda()
        arrange(planet: miranda, target: uranus.gravitationalFieldNode)
        orbit(planet: miranda)
        spin(planet: miranda)
        let oberon = viewOberon()
        arrange(planet: oberon, target: uranus.gravitationalFieldNode)
        orbit(planet: oberon)
        spin(planet: oberon)
        let umbriel = viewUmbriel()
        arrange(planet: umbriel, target: uranus.gravitationalFieldNode)
        orbit(planet: umbriel)
        spin(planet: umbriel)
        let ariel = viewAriel()
        arrange(planet: ariel, target: uranus.gravitationalFieldNode)
        orbit(planet: ariel)
        spin(planet: ariel)

        let pluto = viewPluto()
        let charon = viewCharon()
        arrange(planet: charon, target: pluto.gravitationalFieldNode)
        orbit(planet: charon)
        spin(planet: charon)
        self.hideUserInterface {
            self.planetNameButton.alpha = 1
            self.descriptionView.alpha = 1
            self.mapButton.alpha = 1
            self.resetButton.alpha = 1
            self.planetNameButton.setTitle("T.B.S.A.U.", for: .normal)
            self.descriptionView.text = "Copyright © 2017 Near Future Marketing"
            self.showUserInterface()
        }
    }
    
    
    func arrange(planet: Planet, target: SCNNode) {
        planet.orbitalPositionNode.addChildNode(planet.gravitationalFieldNode)
        planet.gravitationalFieldNode.addChildNode(planet.planetNode)
        target.addChildNode(planet.orbitalPositionNode)
    }
    
    
    func objectSelected(selectedPlanet: Planet) {
        let planet = selectedPlanet
        let selectedNode = SCNNode(geometry: SCNSphere(radius: CGFloat(selectedPlanet.radius + (selectedPlanet.radius/10))))
        selectedNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        selectedNode.geometry?.firstMaterial?.transparency = 0.5
        selectedPlanet.planetNode.addChildNode(selectedNode)
    }
    
    func orbit(planet: Planet) {
        planet.orbitalPositionNode.removeAllAnimations()
        let selectedPlanet = planet
        let orbitAnimation = CABasicAnimation(keyPath: "rotation")
        orbitAnimation.duration = selectedPlanet.orbitLength
        orbitAnimation.fromValue = SCNVector4Make(0, 2, 1, 0)
        orbitAnimation.toValue = SCNVector4Make(0, 2, 1, Float(Double.pi) * 2.0)
        orbitAnimation.repeatCount = Float.greatestFiniteMagnitude
        selectedPlanet.orbitalPositionNode.addAnimation(orbitAnimation, forKey: "\(planet.name) Orbit Parent")
    }
    
    func pauseOrbit(orbitalPositionNode: SCNNode) {
        orbitalPositionNode.removeAllAnimations()
    }
    
    func spin(planet: Planet) {
        let selectedPlanet = planet
        let spin = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: planet.dayLength))
        planet.planetNode.runAction(spin)
    }
    
    func destroyMoons() {
        omniGravityNode.enumerateChildNodes { (orbitalPositionNode, stop) -> Void in
            orbitalPositionNode.removeFromParentNode()
        }
    }
    
} //END OF PAGE
extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/100}
}


